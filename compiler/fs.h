#pragma once

#include "base.h"
#include <sys/stat.h>

#include <unistd.h>

BOOL existFolder(const STRING folderName)
{
    return access(folderName, F_OK) == 0;
}

void createFolder(const STRING folderName)
{
    mkdir(folderName, 0755);
}
