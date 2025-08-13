#pragma once

#include "base.h"

#define LOG(str) printf(str "\n")
#define INFO(str) LOG("[+] " str)
#define ERROR(str)       \
	{                    \
		LOG("[-] " str); \
		return 1;        \
	}

#define EXE(command) system(command)
