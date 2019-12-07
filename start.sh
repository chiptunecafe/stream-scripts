#!/bin/bash

echo '{ "command": ["set_property", "pause", false] }' | socat - ./mpv_ipc
