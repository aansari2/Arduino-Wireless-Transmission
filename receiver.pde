//Receiver.pde
#include <VirtualWire.h>
int speaker = 0;
char speakerNumber = '1';
char testNumber = '*'; //Common for all receivers

void setup(){
  pinMode(speaker,1);
  vw_set_rx_pin(4);
  vw_set_ptt_inverted(true); // Required for DR3100
  vw_setup(500);	 // Bits per sec
  vw_rx_start();       // Start the receiver PLL running
}
void loop(){
  uint8_t buf[VW_MAX_MESSAGE_LEN];
  uint8_t buflen = VW_MAX_MESSAGE_LEN;

  if (vw_get_message(buf, &buflen)) // Non-blocking
  {
    if ((buf[0]==speakerNumber) || (buf[0]=='*')) activateSpeaker(); 
  }
}
void activateSpeaker(){
  for(int i = 0; i < 3;i++){
    for(int n = 0;n < 50; n++){
      digitalWrite(speaker,1);
      delayMicroseconds(240);
      digitalWrite(speaker,0);
      delayMicroseconds(1800);
    }
    delay(20000);//this is supposed to 500 but for some reason 40000 works
  }
}
