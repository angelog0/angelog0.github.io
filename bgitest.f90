!
! On OSX Yosemite 10.10:
!
! cd ~/work
! wget http://libxbgi.sourceforge.net/xbgi-364.tar.gz
! tar -xf xbgi-364.tar.gz
! cd xbgi-364/src
! make CFLAGS='-O2 -I/usr/X11/include'
! make CFLAGS='-O2 -I/usr/X11/include' LIB='libXbgi.a \
!   -L/usr/X11/lib -lX11 -lm' demo
! make clean
! cd test
! make CFLAGS='-O2 -I/usr/X11/include' LIBS='-L/usr/X11/lib -lX11 -lm'
!
! cd ~/programming.apps/bgi.apps
! gfortran[-mp-4.9] -Wall \
!   -J ../modules bgitest.f90 \
!   -L ../lib -lXbgi -L /usr/X11/lib -lX11 -lm \
!   -o libXbgi_bgitest.out
!
! ./bgitest.out
!
! ------------------------------------------------------------------
!
! On Cygwin64 1.7.33 (test):
!
! cd ~/work
! wget http://libxbgi.sourceforge.net/xbgi-364.tar.gz
! tar -xf xbgi-364.tar.gz
! cd xbgi-364/src
! make
! make demo
!
!   START THE X SERVER
!
! DISPLAY=127.0.0.1:0.0 ./demo
! make clean
! cd test
! make
! DISPLAY=127.0.0.1:0.0 ./mandelbrot
!
! cd ~/programming.apps/bgi.apps
! gfortran -Wall -J ../modules bgi.f90 bgitest.f90 \
!   -L ~/work/xbgi-364/src -lXbgi -lX11 -lm \
!   -o libXbgi_bgitest.out
!
! DISPLAY=127.0.0.1:0.0 ./libXbgi_bgitest.out
!
! ------------------------------------------------------------------
!
! cd ~/work
! wget http://libxbgi.sourceforge.net/SDL_bgi-1.0.0.tar.gz
! tar -xf SDL_bgi-1.0.0.tar.gz
! cd SDL_bgi-1.0.0/src
! make SDL_bgi.o
! cd Test
! make SDL_bgi=../SDL_bgi.o
!
!   START THE X SERVER
!
! DISPLAY=127.0.0.1:0.0 ./mandelbrot
!
! cd ~/programming.apps/bgi.apps
! gfortran -Wall -J ../modules bgitest.f90 \
!   ~/work/SDL_bgi-1.0.0/src/SDL_bgi.o -lSDL -lSDL_gfx \
!   -o SDL_bgi_bgitest.out
!
! Also this works:
!   gfortran -Wall -J ../modules bgitest.f90 \
!   ~/work/SDL_bgi-1.0.0/src/SDL_bgi.o \
!     `pkg-config --cflags --libs SDL_gfx` -o SDL_bgi_bgitest.out
!
! DISPLAY=127.0.0.1:0.0 ./SDL_bgi_bgitest.out
!

module bgi
  use, intrinsic :: iso_c_binding, only: C_INT, C_CHAR
  implicit none
  private

  interface
     subroutine close_graph() bind(C, name = 'closegraph')
       import
     end subroutine close_graph
  end interface

  interface
     function get_ch() bind(C, name = 'getch')
       import
       integer(C_INT) :: get_ch
     end function get_ch
  end interface

  interface
     function get_pixel(x,y) bind(C, name = 'getpixel')
       import
       integer(C_INT) :: get_pixel
       integer(C_INT), intent(in), value :: x, y
     end function get_pixel
  end interface

  interface
     subroutine init_graph(graphdriver,graphmode,pathtodriver) &
          bind(C, name = 'initgraph')
       import
       integer(C_INT), intent(inout) :: graphdriver, graphmode
       character(C_CHAR), intent(in) :: pathtodriver(*)
     end subroutine init_graph
  end interface

  interface
     subroutine put_pixel(x,y,c) bind(C, name = 'putpixel')
       import
       integer(C_INT), intent(in), value :: x, y, c
     end subroutine put_pixel
  end interface

  interface
     subroutine out_text_xy(x,y,textstring) bind(C, name = 'outtextxy')
       import
       integer(C_INT), intent(in), value :: x, y
       character(C_CHAR), intent(in) :: textstring(*)
     end subroutine out_text_xy
  end interface

  public :: close_graph, get_ch, get_pixel, init_graph, put_pixel, &
       out_text_xy

end module bgi

program bgitest
  use, intrinsic :: iso_c_binding, only: C_NULL_CHAR
  use bgi, only: close_graph, get_ch, get_pixel, init_graph, put_pixel, &
       out_text_xy
  implicit none

  integer, parameter :: X11 = 11, X11_800x600 = 6, WIDTH = 800, HEIGHT = 600, &
       MAX_COLOR = 15, NPTS = 5000
  integer :: i, x, y, c, k, gd = X11, gm = X11_800x600
  real :: r(3)

  call init_graph(gd,gm,''//C_NULL_CHAR)

  call random_seed()
  do i = 1, NPTS
     call random_number(r)

     x = int(r(1)*WIDTH)
     y = int(r(2)*HEIGHT)
     c = 1+int(r(3)*MAX_COLOR)

     call put_pixel(x,y,c)
  end do

  call random_seed()
  do i = 1, NPTS
     call random_number(r)

     x = int(r(1)*WIDTH)
     y = int(r(2)*HEIGHT)
     c = get_pixel(x,y)

     if (c == 1+int(r(3)*MAX_COLOR)) call put_pixel(x,y,0)
  end do

  call out_text_xy(0,20,'Press a key to quit'//C_NULL_CHAR)
  k = get_ch()
  call close_graph()

end program bgitest
