0:
shell "clear"
cls
color 7
print "##  BlackBerry Android Media Backup & Restore V1.2a  ##"
print "## Developed by Page Telegram 2019, pagetelegram.com ##"
print "##---------------------------------------------------##"
print "## [B]ackup ## [R]estore ## [U]nzip Backup ## [Q]uit ##"
print "##---------------------------------------------------##"
print "##            [I]nstall & Dependencies               ##"
print "##---------------------------------------------------##"
ext=0

do
 select case ucase$(inkey$)
  case "B":
   1:print "Please connect Android device to computer and make sure device is in debug mode"
    sleep 2
    print "Press any key to continue..."
    sleep
    shell "adb devices"
    input "Do you see your device listed above?>",yorn$
    if left$(ucase$(yorn$),1)="N"  then goto 1:
    color 14
    print "Do not disconnect or press keys until process has finished!"   
    color 7
    shell "date +'%y-%m-%d_%H-%M-%S' > datetime.dat"
    open "datetime.dat" for input as #1
    input #1,dt$
    close #1
    shell "rm datetime.dat"
   shell "adb backup -apk -shared -all -f ~/bbdroid/backup/ad"+dt$+".ab"
   shell "adb pull /sdcard ~/bbdroid/backup/sd"+dt$+".ab"
   rem print "Now grabbing SMS/Phone Logs"
   rem shell "adb root"
   rem shell "adb pull /data/data/com.android.providers.telephony/databases/mmssms.db ~/bbdroid/backup/"
   color 12
   print "Backup finishd! You may now disconnect your device."
   sleep 10
   goto 0:
  case "R":
   2:print "Please connect restore device to computer and make sure device is in debug mode"
   sleep 2
   print "Press any key to continue...."
   sleep
   shell "adb devices"
   input "Do you see your device listed above?>",yorn$
    if left$(ucase$(yorn$),1)="N" then goto 2:
    print "SD Card Backups"
   shell "ls ~/bbdroid/backup/sd*"
   print "Phone Backups"
   shell "ls ~/bbdroid/backup/ad*"
   input "Which file to restore to device?>",fil$
   shell "adb restore ~/bbdroid/backup/"+fil$  
   sleep 10
   goto 0:
  case "U":
   print "SD Card Backups"
   shell "ls ~/bbdroid/backup/sd*"
   print "Phone Backups"
   shell "ls ~/bbdroid/backup/ad*"
   input "Which file to unzip?>",fil$
   input "What is your password for encrypted file?>",pass$
   dr$=left$(fil$,17)
   shell "echo on"
   shell "mkdir ~/bbdroid/backup/"+dr$+"/"
   shell "java -jar ~/bbdroid/backup/abe.jar unpack ~/bbdroid/backup/"+fil$+" ~/bbdroid/backup/"+dr$+"/current.tar "+pass$
   shell "tar -xvf ~/bbdroid/backup/"+dr$+"/current.tar -C ~/bbdroid/backup/"+dr$+"/"
   shell "rm ~/bbdroid/backup/"+dr$+"/current.tar"
   sleep 10
   goto 0:
  case "Q":ext=1
  case "I":
   shell "cd ~/"
   shell "mkdir ~/bbdroid"
   shell "mkdir ~/bbdroid/backup"
   shell "sudo apt-get install default-jdk software-properties-common"
   shell "sudo add-apt-repository ppa:linuxuprising/java"
   shell "sudo apt-get update"
   shell "sudo apt-get install java-common"
   shell "apt-get install adb"
   shell "wget -P ~/bbdroid/ https://sourceforge.net/projects/adbextractor/files/android-backup-tookit-20180521.zip"
   shell "unzip *.zip"
   shell "sudo dpkg -i ~/bbdroid/android-backup-toolkit/star-bin/star-ubuntu-lucid/star_1.5final-2ubuntu2_amd64.deb"
   shell "wget -P ~/bbdroid/backup/ https://downloads.sourceforge.net/project/adbextractor/abe.jar"
   sleep 10
   goto 0
 end select
loop until ext=1
