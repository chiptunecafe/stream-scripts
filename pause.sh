#!/bin/bash

echo '{ "command": ["set_property", "pause", true] }' | socat - ./mpv_ipc
