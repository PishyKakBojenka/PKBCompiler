module Library
contains
!To the web
!1) error in get output path with C:\ (recomend to use drag and drop)

!Get File Path
character*500 function GetPath(os)
character path*500,s*5,os*3
logical exst
2 call Clear(os)
write (*,*) 'Please enter your file path. (or drag and drop your file on this window)'
read (*,1) path
1 format (A500)
inquire(file=path, exist=exst)
if (exst .EQV. .false.) then
write (*,*) 'Error. Entered file do not exist.'
write (*,*) 'Try again or exit?'
write (*,*) '1) Try again.'
write (*,*) '2) Exit.'
write (*,*)
write (*,*) 'Choose one of the options:'
read (*,*) s
write (*,*)
if (s .EQ. '1') then
goto 2
endif
if (s .EQ. '2') then
goto 3
endif
endif
GetPath=path
3 continue
end function GetPath

!Get Output Path
character*500 function GetOutputPath(os,output_path_was)
character path*500,s*5,os*3,name*500,output_path_was*500,extra*500
logical exst
2 call Clear(os)
write (*,*) 'Please enter path where you want your file to be outputed. (or drag and drop your file on this window)'
read (*,1) path
path=ADJUSTL(path)
1 format (A500)
inquire(file=path, exist=exst)



if (exst .EQV. .false.) then
write (*,*)
write (*,*) 'Error. Entered path do not exist. (',path(1:len_trim(path)),' )'
write (*,*) 'Try again or exit?'
write (*,*) '1) Try again.'
write (*,*) '2) Exit.'
write (*,*)
write (*,*) 'Choose one of the options:'
read (*,*) s
write (*,*)
if (s .EQ. '1') then
goto 2
endif
if (s .EQ. '2') then
GetOutputPath=output_path_was
goto 3
endif
endif

! folder or file check
open (1, file=path, err=6)
write (*,*)
write (*,*) 'Error. Entered path was a file. (',path(1:len_trim(path)),' )'
write (*,*) 'Try again or exit?'
write (*,*) '1) Try again.'
write (*,*) '2) Exit.'
write (*,*)
write (*,*) 'Choose one of the options:'
read (*,*) s
write (*,*)
if (s .EQ. '1') then
goto 2
endif
if (s .EQ. '2') then
GetOutputPath=output_path_was
goto 3
endif
6 continue
close (1)


if (os .NE. 'win')then
if (path(len_trim(path):len_trim(path)) .NE. '/') then
extra=path
write (path,*)extra(1:len_trim(extra)),'/'
endif
else
if (path(len_trim(path): len_trim(path)) .NE. '\') then
extra=path
write (path,*)extra(1:len_trim(extra)),'\'
endif
endif


write (*,*) 'Please enter output file name. (no extension needed)'
read (*,1) name
extra=path
if (os .NE. 'win')then
write (path,*)extra(1:len_trim(extra)),name(1:len_trim(name))
else
write (path,*)extra(1:len_trim(extra)),name(1:len_trim(name))
endif
GetOutputPath=path
3 continue
end function GetOutputPath

!Get File Name
character*50 function GetName(s,os)
character s*500,os*3
integer last
do i=1,len_trim(s),1
if (os .NE. 'win') then
if (s(i:i) .EQ. '/') then
last=i
endif
else
if (s(i:i) .EQ. '\') then
last=i
endif
endif
enddo
GetName=s(last+1:len_trim(s))
end function GetName

!Get File Size
integer function GetSize(s)
character s*500
integer file_size
inquire(file=s, size=file_size)
GetSize=file_size
end function GetSize

!Get Number of lines in the file
integer function GetLines(path)
character s*500,path*500
integer lines,reason
lines=0
reason=0
open (1, file=path, action='read')
DO while (reason .GE. 0)
s=''
READ(1,2,IOSTAT=reason)  s
2 format (a500)
lines=lines+1
enddo
close (1)
GetLines=lines-1
end function GetLines

!Call Server
Subroutine CallServer(os,action,value,object,field,current_path)

character command*50000,server_url*5000,url*5000,action*100,value*100,object*100,field*100,os*3,current_path*500
write (server_url,*) 'https://script.google.com/macros/s/AKfycbxxUQ1PWG12YlmlKghDrZY5yEi34TFZFCBvUEp569toSoYau6Nr/exec'
server_url=ADJUSTL(server_url)

write (action,*)'GetValue'
action=ADJUSTL(action)

write (value,*)' '
value=ADJUSTL(value)

write (object,*)'lamp1'
object=ADJUSTL(object)

write (field,*)'color'
field=ADJUSTL(field)

write (url,*) server_url(1:len_trim(server_url)),'?Action=',action(1:len_trim(action)),'&Object=',object(1:len_trim(object)),&
'&Field=',field(1:len_trim(field)),'&Value=',value(1:len_trim(value))
url=ADJUSTL(url)
!файл ответа будет в папке, откуда вызывалась прога
if (os .NE. 'win')then
write (command,*) 'wget -O ',current_path(1:len_trim(current_path)),'/answer.txt -q "',url(1:len_trim(url)),'"'
else
write (command,*) current_path(1:len_trim(current_path)),'\Rtools\bin\wget.exe -O ',current_path(1:len_trim(current_path)),&
'\answer.txt -q "',url(1:len_trim(url)),'" --no-check-certificate'
endif
command=ADJUSTL(command(1:len_trim(command)))
call system (command(1:len_trim(command)))
end Subroutine CallServer

!Clear
Subroutine Clear(os)
character os*3
if (os .NE. 'win') then
call system ('clear')
else
call system ('cls')
endif
end Subroutine Clear

end module Library