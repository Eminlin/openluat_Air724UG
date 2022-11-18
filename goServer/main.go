package main

import (
	"bytes"
	"encoding/binary"
	"fmt"
	"net"
	"os"
	"strconv"
	"time"
)

func main() {
	// 建立 tcp 服务
	listen, err := net.Listen("tcp", "0.0.0.0:8080")
	if err != nil {
		fmt.Printf("listen failed, err:%v\n", err)
		return
	}
	fmt.Println("server listen start")
	for {
		conn, err := listen.Accept()
		if err != nil {
			fmt.Printf("accept failed, err:%v\n", err)
			continue
		}
		go process(conn)
	}
}
func GetDetailTime() string {
	now := time.Now()
	return fmt.Sprintf("%02d%02d%02d%02d%02d%02d", now.Year(), int(now.Month()),
		now.Day(), now.Hour(), now.Minute(), now.Second())
}

func process(conn net.Conn) {
	defer conn.Close()
	var buf [4096]byte
	var imageData [100 * 1024]byte
	for {
		n, _ := conn.Read(buf[0:])
		size, _ := strconv.Atoi(string(buf[0:n]))
		if size > 0 {
			fmt.Println("------------------------file size--------------------", size)
			i := 0
			for i < size {
				n, _ := conn.Read(imageData[i:])
				i += n
			}
			imgName := fmt.Sprintf("%s.jpg", GetDetailTime())
			byte2image(imageData, i, imgName)
			break
		}
	}
	conn.Close()
}

func byte2image(b [100 * 1024]byte, n int, path string) {
	fp, err := os.Create(path)
	if err != nil {
		fmt.Println(err)
		return
	}
	defer fp.Close()

	buf := new(bytes.Buffer)
	binary.Write(buf, binary.LittleEndian, b[0:n])
	fp.Write(buf.Bytes())
}
