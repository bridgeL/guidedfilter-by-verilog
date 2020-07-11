## 基于verilog实现的导向滤波算法

2020/7/10



#### [注意]

所有代码文件中的旧版本代码已被弃用，请使用最新版本号的文件夹内的代码

旧版代码仅用于项目过程自证

例如

---- matlab

   -- *ver1（已被弃用）*

   -- *ver2（已被弃用）*

   -- *ver3（已被弃用）*

  -- <u>ver4（最新可用代码）</u>



#### 小组作品

**小组成员**：李，赵，王



#### 小组分工

**李**：负责verilog代码部分，实现了导向滤波算法；编写了python代码预处理图片，转换为txt文件供仿真读取

**王**：前期资料搜集整理，使用matlab代码测试导向滤波算法性能

**赵**：分析导向滤波算法原理，撰写报告



#### 优点

基于verilog实现了导向滤波算法，独立完成

实现了图片的读入读出，对图片的模糊处理，边缘细节的保留

可以调节美颜的力度，由顶层文件的eps端口控制

matlab、python、verilog等代码结构清晰，资料完整，报告全面



#### 有待改进点

ram使用过多，无法在Cyclone IV系列的板子上布局，因此本项目尚处在在仿真成功的阶段，仍有很大的进步空间



