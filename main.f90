!SmartHomeProject compiler made by PishyKakBojenka Company.
!It's an open source project so fill free to use it.
!To compil your own compiler note to change the "os".
!Use "win" for windows, or it will use linux based commands.

include "library.f90"
include "compiler.f90"
!Идеи:
!1) нужен os detector

program kursach

use Library
use Compiler
!серверные перемненные
character command*50000,server_url*5000,url*5000,action*100,value*100,object*100,field*100,extra*500
!переменные для авторизации
character user*100,password*100
!переменные билда
!переменные для работы с файлом
character os*3,version*10
character file_name*50
integer file_size,file_lines
character s*50,path*500,current_path*500,output_path*500
!доп переменные
integer choosen
logical exst,comfile

!определение системы
os='win'
CALL getcwd(current_path)


!версия компилятора
version='Alfa 0.2.5'
file_name='none'
if (os .NE. 'win')then
write(output_path,*) current_path(1:len_trim(current_path)),'/output_file'
else
write(output_path,*) current_path(1:len_trim(current_path)),'\output_file'
endif
file_size=0
file_lines=0
comfile= .false.
!обращение к серверу
!//////////////
call CallServer(os,action,value,object,field,current_path)
!//////////////
1 continue
call Clear(os)
choosen=0
!Интерфейс
write (*,*) 'Welcome to the SmartHomePorject compiler. Version: ',version
write (*,*)
write (*,*) 'Working with file: ',file_name(1:len_trim(file_name)),'| Size: ',file_size, 'byte| Lines: ',file_lines,'|'
write (*,*)
write (*,*) 'Output file: ',output_path(1:len_trim(output_path))
do while (choosen .NE. 1)
write (*,*)
write (*,*) '1) Open file.'
write (*,*) '2) Update file.'
write (*,*) '3) Output path.'
write (*,*) '4) Compile file.'
write (*,*) '5) Exit compiler.'
write (*,*)
write (*,*) 'Choose one of the options:'
read (*,*) s
write (*,*)

!открытие файла
if (s .EQ. '1') then
choosen=1
path=GetPath(os)
file_name=GetName(path,os)
file_size=GetSize(path)
file_lines=GetLines(path)
comfile=.true.
goto 1
endif

!обновление файла
if (s .EQ. '2') then
choosen=1
inquire(file=path, exist=exst)
if ((path .EQ. '') .or. (exst .EQV. .false.)) then
write (*,*)'Error. No file found.'
call sleep(3)
endif
if (exst) then
file_size=GetSize(path)
file_lines=GetLines(path)
endif
goto 1
endif

!выходной путь
if (s .EQ. '3') then
choosen=1
output_path=GetOutputPath(os,output_path)
output_path=adjustl(output_path)
goto 1
endif

!компиляция файла
if (s .EQ. '4') then
choosen=1
If (comfile.EQV..false.) THEN
    call Clear(os)
    Write(*,*)'Error! You must choose file to compile.'
    call sleep(3)
    goto 1 
    else
CALL getcwd(current_path)

call Reader(path,current_path,os,file_lines)
!call Clear(os)
!write (*,*) 'This function is coming in the future builds.'
!call sleep(3)
go to 1
endif
endif

!выход из проги
if (s .EQ. '5') then
choosen=1
call Clear(os)
write (*,*) 'Have a nice day! ;)'
call sleep(3)
goto 9999
endif

if (choosen .NE. 1) then
write (*,*) 'Error. Unknown command.'
endif
enddo

9999 continue
end program kursach
