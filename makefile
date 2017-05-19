CXX       = g++
CPP_FILES = $(wildcard *.cpp)
OBJS      = $(patsubst %.cpp,%.o,$(CPP_FILES))
CXXFLAGS  = -O3 -Wall -Werror -pedantic-errors -fmessage-length=0 -g -std=c++11
TARGET    = commonwordfinder

all: $(TARGET)
$(TARGET): $(OBJS)
	$(CXX) $(OBJS) -o $(TARGET)
%.o: %.cpp %.h
	$(CXX) $(CXXFLAGS) -c -o $@ $<
clean:
	rm -f $(OBJS) $(TARGET) $(TARGET).exe
