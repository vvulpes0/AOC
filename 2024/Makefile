.SUFFIXES :
.SUFFIXES : .java .class .jar

.java.class :
	javac -d . -Xlint:unchecked $(.IMPSRC)
.class.jar :
	jar -cvfe $(.TARGET) $(.PREFIX) $(.PREFIX)*.class
