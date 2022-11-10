# Excel导表
&emsp;&emsp;策划配置的Excel数值在游戏服启动时一般是需要加载到内存中，加速配置文件的读取。
因此在开发中一般都有自己的一套规则，工具，我们实现的方式是将excel读取写入到MongoDB数据库中，服务器启动从数据库中加载缓存到内存中。
参考项目[game-server/game-tool](https://github.com/jzyong/game-server/tree/master/game-tool),
[格式设计](https://github.com/jzyong/game-server/wiki/%E5%AF%BC%E8%A1%A8%E5%B7%A5%E5%85%B7)

