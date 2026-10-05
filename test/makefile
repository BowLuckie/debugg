CXX      := g++
CXXFLAGS := -Wall -Wextra -std=c++17 -g -gdwarf-4 $(EXTRA_CXXFLAGS)

SRCS     := $(wildcard *.cpp)
OBJS     := $(SRCS:.cpp=.o)
TARGET   := test.bin

.PHONY: all clean run

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJS) $(LN_OBJ)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(TARGET) $(OBJS)

run: $(TARGET)
	./test.bin
