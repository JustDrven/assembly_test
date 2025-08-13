#include "logger.h"
#include "fs.h"
#include <string.h>

#define COMPILE_FOLDER "build/"

#define FILE_OUTPUT COMPILE_FOLDER "main.o"
#define FILE_TO_COMPILE COMPILE_FOLDER "main.run"

// only for macOS
#define NASM_COMMAND "nasm -f macho64 -o " FILE_OUTPUT
#define LINKER_COMMAND "ld -o " FILE_TO_COMPILE " " FILE_OUTPUT " -lSystem -syslibroot $(xcrun --show-sdk-path) -e _start -arch x86_64 -platform_version macos 12.0 12.0"

int main(int argc, char const *argv[])
{

	if (!existFolder(COMPILE_FOLDER)) {
		createFolder(COMPILE_FOLDER);

		INFO(COMPILE_FOLDER " folder has been created");
	}

	if (argc != 2)
	{
		ERROR("You need specify assembly file!");
	}

	char nasmCommand[256];

	snprintf(nasmCommand, sizeof(nasmCommand), "%s %s", NASM_COMMAND, argv[1]);

	INFO("Compiler is starting..");

	int nasmStatus = EXE(nasmCommand);
	if (nasmStatus != 0)
	{
		ERROR("An error with nasm command, please check compiler");
	}

	int linkerStatus = EXE(LINKER_COMMAND);
	if (linkerStatus != 0)
	{
		ERROR("An error with linker command, please check compiler");
	}

	INFO("Compiler is done!");
	return 0;
}
