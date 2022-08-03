# WireShark

### 8 .wireshark使用
使用wireshark 网络包分析 
   
    # 1.创建文件&添加权限
    touch packet.txt
    chmod o+x packet.txt

    # 2.查看网络接口
    tshark -D
    
    # 3.记录
    tshark -w packet.txt -i eth0 -q

    # 4.控制台查看指定端口(非常消耗内存)
    tshark -i eth0 -Y "tcp.port == 40019"
    tshark -i ens5 -Y "tcp.port == 7050"
