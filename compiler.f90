module Compiler
contains
!Идеи:
!1) шапка регистрации при запуске программы
!2) как записать в файл что либо в ''?

Subroutine Reader (path,current_path,os,file_lines)
character path*500,current_path*500,os*3,extra*500,s*200,brackets_extra*15
character*100, dimension (:),allocatable :: brackets
character*100, dimension (:),allocatable :: lamps
character*100, dimension (:),allocatable :: tvs
character*100, dimension (:),allocatable :: alarms
integer end_file,line,file_lines,bracket,lamps_c,tvs_c,alarms_c,errornum
logical started
!скобки if/do/while/end
allocate (brackets(file_lines*2))
allocate (lamps(file_lines*2))
allocate (tvs(file_lines*2))
allocate (alarms(file_lines*2))
bracket=1
lamps_c=1
tvs_c=1
alarms_c=1

open (1, file=path, action='read')
if (os .NE. 'win') then
write (extra,*)current_path(1:len_trim(current_path)),'/temp.f90'
else
write (extra,*)current_path(1:len_trim(current_path)),'\temp.f90'
endif
current_path=adjustl(extra)
100 open (10, file=current_path, status='new',err=101,iostat=errornum)
! Проверка на существование временного файла temp.f90 
! И удаление, если он существует
101 IF(errornum.NE.0) THEN
 open (10, file=current_path)
    close(10,status='delete')
    goto 100
    ENDIF
!Шапка регистрации
write (10,*) '!This program was created using "SmartHomeProject Compiler"'
write (10,*) '!Open source language by "PishyKakBojenka Company"'
call sleep(1)

1 format (A200)
end_file=1
line=1
do while (end_file .GE. 0)
read (1,1,iostat=end_file) s
s=adjustl(s)
write (*,*) s(1:len_trim(s))

!Рай условий!!!!!)))))
do i=1,len_trim(s),1

!заголовок
if ((i .GT. 6) .and. (s(i-6:i) .EQ. 'program'))then
if (i .LT. len_trim(s))then
write(10,*) 'program ',s(i+1:len_trim(s))
else
write (*,*) 'Error. No program name found. Line:',line
goto 3
endif
brackets(bracket)='header'
bracket=bracket+1
endif
!конец заголовка


!начало программы
if ((s(i:i) .EQ. '{') .and. (started .EQV. .false.)) then
started=.true.
write (*,*) 'started'
endif

!объекты
if (started .EQV. .false.) then
! типа лампа
if ((i .GT. 4) .and. (s(i-4:i) .EQ. 'lamp ')) then
lamps(lamps_c) = s(i+1:len_trim(s))
write (*,*)lamps(lamps_c),'<--'
lamps_c=lamps_c+1
endif

! типа alarm
if ((i .GT. 5) .and. (s(i-5:i) .EQ. 'alarm ')) then
alarms(alarms_c) = s(i+1:len_trim(s))
write (*,*)alarms(alarms_c),'<--'
alarms_c=alarms_c+1
endif

! типа тв
if ((i .GT. 2) .and. (s(i-2:i) .EQ. 'tv ')) then
tvs(tvs_c) = s(i+1:len_trim(s))
write (*,*)tvs(tvs_c),'<--'
tvs_c=tvs_c+1
endif

endif


!end
if (s(i:i) .EQ. '}')then
bracket=bracket-1
write(*,*)'ender'
!header
if (brackets(bracket) .EQ. 'header') then
write (10,*) 'end program'
endif

endif
!конец end



2 continue !error
enddo !len_trim
!test massage
3 line=line+1
!Конец условий((((((((
enddo !while

9999 continue
close (10)
pause
close (1)
open (10, file=current_path)
close (10,status='delete')

end Subroutine Reader


end module Compiler
