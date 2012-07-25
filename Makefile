CC=gcc
OS=$(shell uname -s | tr '[A-Z]' '[a-z]')

ifeq ("$(OS)", "darwin")
JAVE_HOME=$(shell /usr/libexec/java_home)
JAVA_HEADERS=/Developer/SDKs/MacOSX10.6.sdk/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Headers/
OBJ=libheapster.jnilib
endif

ifeq ("$(OS)", "linux")
JAVA_HOME=/usr/java/default/
JAVA_HEADERS=$(JAVA_HOME)/include -I$(JAVA_HOME)/include/linux
OBJ=libheapster.so
endif

CFLAGS=-Ijava_crw_demo -fno-strict-aliasing                                  \
        -fPIC -fno-omit-frame-pointer -W -Wall  -Wno-unused -Wno-parentheses \
        -I$(JAVA_HEADERS)
LDFLAGS=-fno-strict-aliasing -fPIC -fno-omit-frame-pointer \
        -static-libgcc -shared
DEBUG=-g

all: $(OBJ) Heapster.class

$(OBJ): heapster.o sampler.o util.o java_crw_demo/java_crw_demo.o
	g++ $(DEBUG) $(LDFLAGS) -o $@ $^ -lc

%.o: %.cc
	g++ $(DEBUG) $(CFLAGS) -o $@ -c $<

%.class: %.java
	javac $<

clean:
	rm -f *.o
	rm -f $(OBJ)
	rm -f java_crw_demo/*.o
