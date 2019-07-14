//Receiver Code
int speaker = 0;
int data = 3;
const int del = 204; //could be dynamic for the different keyfobs

void setup() {
  pinMode(data,0);
  pinMode(speaker,1);
}

/*
MEMSIG Array
------ -----
    A - {0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,1,1,0,0,0};-
    B - {0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,1,0,0,0,0,0,0,0};-
    C - {0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,1,1,0};-
    D - {0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,1,1,0,0,0,0,0};-
*/

const int row = 60;
const int col = 6;
byte a[row][col];
boolean MEMSIG[25]={0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,1,1,0,0,0,0,0};
boolean state=0;

void loop() {
  for(int i = 0; i < row;i++){
    for(int j = 0; j < col;j++){
      a[i][j] = digitalRead(data);
      delayMicroseconds(del);
    }
  }
  for(int j = 0; j < col;j++){
    for(int i = 0; i < row-25;i++){
    //at any i or j, if the following condition satisfies
      if(!a[i][j]&&a[i+1][j]&&!a[i+2][j]&&a[i+3][j]&&!a[i+4][j]){
        state = 1;
        for(int k = 0;k<25;k++){// then the whole signal data is verified
          state = (state) && ((a[i+k][j]==MEMSIG[k]));
        }
        if (state){ //if all checks out boolean state remains true
          activateSpeaker(); //activate speaker
          break; //break out of i loop
        }
      }
    }
    if (state) break; //break out of j loop
  }
}
void activateSpeaker(){
  digitalWrite(speaker,1);
  delay(50);
  digitalWrite(speaker,0);
}
/*
void activateSpeaker(){//Incase different sound is needed for different speaker
  digitalWrite(speaker,1);
  delay(20);
  digitalWrite(speaker,0);
  for(int n = 15; n < 25; n++){
    digitalWrite(speaker,MEMSIG[n]);
    delay(10);
  }
  digitalWrite(speaker,1);
  delay(20);
  digitalWrite(speaker,0);
}*/

//Binary sketch size: 1,566 bytes (of a 8,192 byte maximum)
