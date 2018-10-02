---
layout: post
title: "VSCode C++ Environment Setup"
description: ""
category: programming
tags: [c++]
---

建立 `.vscode` 資料夾，在裡面建立兩個文件, 內容如下:

#### c_cpp_properties.json

```json
{
    "configurations": [
        {
            "name": "Mac",
            "includePath": [
                "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1",
                "/usr/local/include",
                "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/8.1.0/include",
                "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include",
                "/usr/include",
                "${workspaceRoot}"
            ],
            "defines": [],
            "intelliSenseMode": "clang-x64",
            "browse": {
                "path": [
                    "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1",
                    "/usr/local/include",
                    "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/8.1.0/include",
                    "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include",
                    "/usr/include",
                    "${workspaceRoot}"
                ],
                "limitSymbolsToIncludedHeaders": true,
                "databaseFilename": ""
            },
            "macFrameworkPath": [
                "/System/Library/Frameworks",
                "/Library/Frameworks"
            ],
            "compilerPath": "/usr/bin/clang",
            "cStandard": "c11",
            "cppStandard": "c++17"
        },
        {
            "name": "Linux",
            "includePath": [
                "/usr/include",
                "/usr/local/include",
                "${workspaceRoot}"
            ],
            "defines": [],
            "intelliSenseMode": "clang-x64",
            "browse": {
                "path": [
                    "/usr/include",
                    "/usr/local/include",
                    "${workspaceRoot}"
                ],
                "limitSymbolsToIncludedHeaders": true,
                "databaseFilename": ""
            },
            "compilerPath": "/usr/bin/clang",
            "cStandard": "c11",
            "cppStandard": "c++17"
        },
        {
            "name": "Win32",
            "includePath": [
                "C:/Program Files (x86)/Microsoft Visual Studio 14.0/VC/include",
                "${workspaceRoot}"
            ],
            "defines": [
                "_DEBUG",
                "UNICODE"
            ],
            "intelliSenseMode": "msvc-x64",
            "browse": {
                "path": [
                    "C:/Program Files (x86)/Microsoft Visual Studio 14.0/VC/include/*",
                    "${workspaceRoot}"
                ],
                "limitSymbolsToIncludedHeaders": true,
                "databaseFilename": ""
            },
            "compilerPath": "/usr/bin/clang",
            "cStandard": "c11",
            "cppStandard": "c++17"
        }
    ],
    "version": 4
}
```

#### tasks.json

```json
{
    "command": "g++",
    "args": [
        "-Wall",
        "-o",
        "main.out",
        "main.cpp",
        "-std=c++11",
        "&&",
        "./main.out"
      ],
    "type":"shell",
    "version": "2.0.0",
    "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "shared",
        "showReuseMessage": true
    },
    "problemMatcher": {
        "owner": "cpp",
        "fileLocation": [
            "relative",
            "${workspaceRoot}"
        ],
        "pattern": {
            "regexp": "^(.*):(\\d+):(\\d+):\\s+(warning|error):\\s+(.*)$",
            "file": 1,
            "line": 2,
            "column": 3,
            "severity": 4,
            "message": 5
        }
    }
}
```