/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
? Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : DataLogger
Version : 1.0
Date    : 07/07/2016
Author  : Bleno
Company : Hewlett-Packard
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 14,745600 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256


Graphic LCD initialization
The PCD8544 connections are specified in the
Project|Configure|C Compiler|Libraries|Graphic LCD menu:
SDIN - PORTC Bit 3
SCLK - PORTC Bit 5
D /C - PORTC Bit 4
/SCE - PORTC Bit 2
/RES - PORTC Bit 1

I2C Bus initialization
I2C Port: PORTB
I2C SDA bit: 0
I2C SCL bit: 1

*****************************************************/

#include <mega8.h>

// I2C Bus functions
#include <i2c.h>

// LM75 Temperature Sensor functions
#include <lm75.h>

// DS1307 Real Time Clock functions
#include <ds1307.h>

// Graphic LCD functions
#include <glcd.h>

// Font used for displaying text
// on the graphic LCD
#include <font5x7.h>

//FUN?OES EXTRAS
#include <delay.h>
#include "batman.h"
#include "icon.h"
#include "iconmin.h"
#include "iconmax.h"
#include "iron.h"
#include "save.h"
#include "cel.h"

unsigned int flag=0;
unsigned char hour, mint, sec, day, month, year, sem, msg[18],msgmin[8], msgmax[8], temp[7]; 
unsigned int i=0, z, tempmin=500, tempmax=-300, q=0, y=0, comando;


char teste[];

// Function used for reading image
// data from external memory
unsigned char read_ext_memory(GLCDMEMADDR_t addr)
{
unsigned char data;
// Place your code here

return data;
}

// Function used for writing image
// data to external memory
void write_ext_memory(GLCDMEMADDR_t addr, unsigned char data)
{
// Place your code here

}

#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
flag=1;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index++]=data;
#if RX_BUFFER_SIZE == 256
   // special case for receiver buffer size=256
   if (++rx_counter == 0) rx_buffer_overflow=1;
#else
   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      }
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE <= 256
unsigned char tx_wr_index,tx_rd_index,tx_counter;
#else
unsigned int tx_wr_index,tx_rd_index,tx_counter;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index++];
#if TX_BUFFER_SIZE != 256
   if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index++]=c;
#if TX_BUFFER_SIZE != 256
   if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
#endif
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>
// Declare your global variables here
unsigned char comand;

//FUN??O PARA RECEBER A HORA E O DIA DO RTC E TRANSFORMAR EM CARACTER DA ASCII 
void horaDia()   
{
    rtc_get_time(&hour,&mint,&sec); 
    msg[0]=(hour/10)+48;
    msg[1]=(hour%10)+48;
    msg[2]=':';
    msg[3]=(mint/10)+48;
    msg[4]=(mint%10)+48;
    msg[5]=':';
    msg[6]=(sec/10)+48;
    msg[7]=(sec%10)+48;
    
    rtc_get_date(&sem,&day,&month,&year); 
    msg[8]=(day/10)+48;
    msg[9]=(day%10)+48;
    msg[10]='/';
    msg[11]=(month/10)+48;
    msg[12]=(month%10)+48;
    msg[13]='/';
    msg[14]=2+48;
    msg[15]=48;
    msg[16]=((year%100)/10)+48;
    msg[17]=(year%10)+48;
    
}

//FUN??O PARA RECEBER A TEMPERATURA DO LM75
void tempt()
{
    int temperatura;
    temp[0]=' ';   //sinal da temperatura
    temperatura=lm75_temperature_10(0);  //recebe a temperatura do lm75 multiplicada por 10 
/*    
    if(tempmax<temperatura)
    {
        tempmax=temperatura;
        rtc_get_time(&hour,&mint,&sec);
        msgmax[0]=(hour/10)+48;
        msgmax[1]=(hour%10)+48;
        msgmax[2]=':';
        msgmax[3]=(mint/10)+48;
        msgmax[4]=(mint%10)+48;
        msgmax[5]=':';
        msgmax[6]=(sec/10)+48;
        msgmax[7]=(sec%10)+48;
    }
        
    
    if(tempmin>temperatura)
    {
        tempmin=temperatura;
        rtc_get_time(&hour,&mint,&sec);
        msgmin[0]=(hour/10)+48;
        msgmin[1]=(hour%10)+48;
        msgmin[2]=':';
        msgmin[3]=(mint/10)+48;
        msgmin[4]=(mint%10)+48;
        msgmin[5]=':';
        msgmin[6]=(sec/10)+48;
        msgmin[7]=(sec%10)+48;
    }
 */     
  
   if(temperatura<0) //sinal negativo caso temperatura <0
    {
        temp[0]='-';
        temperatura=-temperatura;
    }
    if(temperatura<100)
    temp[1]=' ';
    else                     
    temp[1]=(temperatura/100)+48;
        
    temp[2]=((temperatura%100)/10)+48;
    temp[3]='.';
    temp[4]=(temperatura%10)+48;
    temp[5]=' ';
    temp[6]='C'; 
    
}


//FUN??O PARA SALVAR NA EEPROM
void save()
{
    int p=0;
    horaDia();
    q=y+8;
    while(y<q)
    {
        teste[y]=msg[p]; 
        y++;
        p++;
    } 
    
    teste[y]=' ';
    y++;
    
    tempt();
    q=y+7;
    p=0;    
    while(y<q)
    {        
        teste[y]=temp[p];
        p++;
        y++; 
    }
    
    teste[y]='\n';
    y++;

}

//FUN??O PARA ENVIAR OS DADOS PELO BLUETOOTH
void send()
{
    int z=0; 
    for(i=8;i<18;i++)
    {
        putchar(msg[i]);
    }
    putchar('\n');
    
    while(z<q)
    {   
        putchar(teste[z]);
        z++;
    } 
}


//FUN??O PARA TRATAR A INTERRUP??O VINDA DO BLUETOOTH
void interrup(char k)
{
    comand=k; 
    glcd_clear();
    glcd_outtext("\nBluetooth\nConexao\nOK...");
    glcd_putimagef(65,5,cel, GLCD_PUTCOPY); 
    delay_ms(2000); 
    if(comand=='a')
    {    
        glcd_clear();
        glcd_outtextxy(0,10,"\n  Iniciando \n   Download..");
        delay_ms(2000);
        
        send();
        
        glcd_outtextxy(0,10,"\n  Download \n   Concluido!");       
        delay_ms(2000);
    }

    comand='0';
}


void main(void)
{
// Declare your local variables here
int j=0, w=0, a;
char k, sign, hourprox;

// Graphic LCD initialization data
GLCDINIT_t glcd_init_data;

// Input/Output Ports initialization
// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0xFF;

// Port C initialization
// Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTC=0x00;
DDRC=0x7F;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 19200
UCSRA=0x00;
UCSRB=0xD8;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x2F;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// I2C Bus initialization
// I2C Port: PORTB
// I2C SDA bit: 0
// I2C SCL bit: 1
// Bit Rate: 100 kHz
// Note: I2C settings are specified in the
// Project|Configure|C Compiler|Libraries|I2C menu.
i2c_init();

// LM75 Temperature Sensor initialization
// thyst: -10?C
// tos: 50?C
// O.S. polarity: 0
lm75_init(0,-10,50,0);

// DS1307 Real Time Clock initialization
// Square wave output on pin SQW/OUT: Off
// SQW/OUT pin state: 0
rtc_init(0,0,0);


// Specify the current font for displaying text
glcd_init_data.font=font5x7;
// No function is used for reading
// image data from external memory
glcd_init_data.readxmem=NULL;
// No function is used for writing
// image data to external memory
glcd_init_data.writexmem=NULL;
// Set the LCD temperature coefficient
glcd_init_data.temp_coef=PCD8544_DEFAULT_TEMP_COEF;
// Set the LCD bias
glcd_init_data.bias=PCD8544_DEFAULT_BIAS;
// Set the LCD contrast control voltage VLCD
glcd_init_data.vlcd=PCD8544_DEFAULT_VLCD;

glcd_init(&glcd_init_data);

 //AJUSTANDO RTC

//day=25;
//month=07;
//year=16;
//rtc_set_time(16,11,10);  
//rtc_set_date(00,day,month,year);




// Global enable interrupts
#asm("sei")

while (1)
      {
      horaDia();
      hourprox=msg[4]+1;     
      pcd8544_setvlcd(63); //Ajusta o Contraste 

      //INICIALIZA?AO
        /*
                // MODO IRON MAN         
      if(j==0)
      {
          glcd_setfont(font5x7);
          j=1; 
          glcd_clear();
          glcd_outtextxy(20,10,"WELCOME\n\n TO DATALOGGER");
          delay_ms(2000); 
          
          while(i<84)
          {
            glcd_clear();
            glcd_putimagef(i,0,iron, GLCD_PUTCOPY); 
            delay_ms(200);
            i++;
             
          }     
        
      };   */   
              

      //RELOGIO MODO BATMAN

      j=0;
      while(j<12)
        {   
            horaDia();
            if(hourprox==msg[4] && w==0)
            {
                save();
                w=1;
            }       
            if(flag==1)
            {   
                k=getchar();
                interrup(k);
                flag=0;
            }
          glcd_clear(); 
          glcd_putimagef(44,0,batman, GLCD_PUTCOPY);  
          
          horaDia();
          
          //HORA
            a=18;
            for(z=0;z<8;z++)
            {   
                glcd_putcharxy(a,18,msg[z]);
                a=a+6;
            }
          
          
          //DIA
            a=14;
            for(z=8;z<18;z++)
            {   
                glcd_putcharxy(a,30,msg[z]);
                a=a+6;
            } 
              
          delay_ms(500);  
          j++;
        }
             

      //TESTE DE CONTRASTE
      /*
      while(i<127)
      {
       pcd8544_setvlcd(i);
       j=(char)i; 
       glcd_putcharxy(30, 31, j);
       delay_ms(300);
       i++;
      }  */  
             

      //DISQUETE
      /*
      glcd_clear(); 
      glcd_putimagef(0,0,save, GLCD_PUTCOPY);    
      delay_ms(4000);   */


      //TERMOMETRO IMPLEMENTADO
      
      j=0; 
      while(j<16)
        { 
             horaDia();
            
            if(hourprox==msg[4] && w==0)
            {
                save();
                w=1;
            }
            
            if(flag==1)
            {
                k=getchar();
                interrup(k);
                flag=0;
            }     
            glcd_clear();
             
            tempt();
             
            glcd_putcharxy(10,20,temp[0]); 
            glcd_putcharxy(16,20,temp[1]);  //+6    PRIMEIRO NUMERO DA TEMPERATURA 
            glcd_putcharxy(22,20,temp[2]);  //+6    SEGUNDO NUMERO DA TEMPERATURA
            glcd_putcharxy(27,21,temp[3]);    //+5
            glcd_putcharxy(31,20,temp[4]);   //+4   TERCEIRO NUMERO DA TEMPERATURA 
            glcd_putcharxy(36,20,temp[5]);
            glcd_putcharxy(42,20,temp[6]);     //+11 
                   
            glcd_putimagef(60,7,icon, GLCD_PUTCOPY);


              
            delay_ms(500);
            j++;   
        } 
      
      w=0;
      }
}
