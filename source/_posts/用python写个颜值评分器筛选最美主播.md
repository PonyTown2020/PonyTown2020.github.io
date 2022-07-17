title: 用python写个颜值评分器筛选最美主播
author: MuyanGit
avatar: 'https://cdn.jsdelivr.net/gh/MuyanGit/ImageHosting/images/favicon.ico'
authorLink: /about/MuyanGit.html
authorDesc: 尽小者大，慎微者著
categories: 技术
comments: true
date: 2021-11-12 20:10:38
authorAbout:
series:
tags: 加密
keywords:
password: Id321cba
abstract: 这里有东西被加密了，需要输入密码查看哦。
message: 您好，这里需要密码。
wrong_pass_message: 抱歉，这个密码看着不太对，请再试试。
wrong_hash_message: 抱歉，这个文章不能被纠正，不过您还是能看看解密后的内容。

------



# 用python写个颜值评分器筛选最美主播

 更新时间：2021年08月26日 17:16:59  作者：Dragon少年  

这篇文章主要介绍了我如何用python写颜值评分器，本文给大家介绍的非常详细，对大家的学习或工作具有一定的参考借鉴价值，需要的朋友可以参考下

##### 目录

- [前言](https://www.jb51.net/article/220934.htm#_label0)

- [一、核心功能设计](https://www.jb51.net/article/220934.htm#_label1)

- - [获取主播直播封面图](https://www.jb51.net/article/220934.htm#_lab2_1_0)
  - [主播颜值评分](https://www.jb51.net/article/220934.htm#_lab2_1_1)

- [二、实现步骤](https://www.jb51.net/article/220934.htm#_label2)

- - [1. 获取主播名称和照片](https://www.jb51.net/article/220934.htm#_lab2_2_2)
  - [2. 主播颜值评分](https://www.jb51.net/article/220934.htm#_lab2_2_3)



## 前言

晚上回家闲来无事，想打开某直播平台，看看小姐姐直播。看着一个个多才多艺的小姐姐，眼花缭乱，好难抉择。究竟看哪个小姐姐直播好呢？

今天我们就一起来做个颜值评分器，爬取小姐姐们的直播照片，对每位小姐姐的颜值进行打分排序，选出最靓的star。



## 一、核心功能设计

总体来说，我们需要做的是获取直播颜值区的主播小姐姐的正在直播的全部主播名称和封面图并保存下来，用百度AI提供的人脸识别接口，进行颜值评分排序，选出颜值最高的。

拆解需求，大致可以整理出核心功能如下：



### 获取主播直播封面图

- 打开直播颜值区模块对页面进行分析
- 发送网络请求，解析数据
- 保存数据



### 主播颜值评分

- 百度人脸识别接口
- 遍历主播照片，调用颜值检测接口对主播颜值进行打分
- 对评分进行排序



## 二、实现步骤



### 1. 获取主播名称和照片

首先我们选择的是某牙直播，进入首页打开颜值区，按F12可以进入开发者模式。

```

# 1.找到数据所在url地址（系统分析网页性质）
url = "https://www.huya.com/g/2168"
headers = {
        'User-Agent': 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
                      '(KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36'
    }

# 2. 发送网络请求-请关闭代理
response = requests.get(url=url, headers=headers)
html_data = response.text
print(html_data)

```

不难发现所有的小姐姐直播封面对应的都是在li标签里面。我们只要解析获取这些li标签数据就可以了。

![在这里插入图片描述](https://cdn.jsdelivr.net/gh/MuyanGit/pic_url@master/img/20210826165210142.jpg)

接着我们需要拿到直播小姐姐的封面图片，通过分析上面li标签里面的内容，可以发现下面有个a标签，里面的img标签中的data-original不就是我们要的小姐姐图片嘛！

![在这里插入图片描述](https://img.jbzj.com/file_images/article/202108/20210826165210143.jpg)

接下来我们想要获取主播小姐姐的名字怎么办呢？点开li标签继续分析，可以看到下面有个span标签，其中的i标签内容就是小姐姐直播的名字。

![在这里插入图片描述](https://img.jbzj.com/file_images/article/202108/20210826165210144.jpg)

网页结构我们上面已经分析好了，那么我们就可以来动手爬取我们所需要的数据了。获取到所有的数据资源之后，把图片保存下来即可。文件的下载保存的方式比较多，我用的是通过 with open打开文件的方式 ，比较简单。

```

# 3. 数据解析
selector = parsel.Selector(html_data)
lis = selector.xpath('//li[@class="game-live-item"]')  # 所有li标签

for li in lis:
    img_name = li.xpath('.//span[@class="avatar fl"]/i/text()').get()  # 主播名字
    img_url = li.xpath('.//a/img/@data-original').get()  # 主播图片地址
    # print(img_name, img_url)

    # 请求图片数据
    img_data = requests.get(url=img_url).content  # 图片数据

    # 4. 数据保存
    # 准备文件名
    file_name = img_name + '.jpg'
    with open('DATA\颜值检测\img\\' + file_name, mode='wb') as f:
        f.write(img_data)
        print('正在保存:', file_name)

```

这样小姐姐的直播名称和照片都可以保存下来了，效果如下：

![在这里插入图片描述](https://img.jbzj.com/file_images/article/202108/20210826165211145.jpg)



### 2. 主播颜值评分

我们调用的是百度开放的人脸识别接口 – [百度AI开放平台链接](https://ai.baidu.com/)。

![在这里插入图片描述](https://img.jbzj.com/file_images/article/202108/20210826165211146.jpg)

这里面我们可以创建一个人脸识别应用，其中的API Key及Secret Key后面我们调用人脸识别检测接口时会用到。

![在这里插入图片描述](https://img.jbzj.com/file_images/article/202108/20210826165211147.jpg)

接下来我们可以看看官方提供的API帮助文档，里面介绍的很详细。包括如何调用请求URL数据格式，向API服务地址使用POST发送请求，必须在URL中带上参数access_token，可通过后台的API Key和Secret Key生成。这里面的API Key和Secret Key就是我们上面提到的。

![在这里插入图片描述](https://img.jbzj.com/file_images/article/202108/20210826165211148.jpg)

那我们要的打分颜值分数是哪个呢？提供返回结果参数，可以看到里面有个beauty就是我们要的颜值分数。

![在这里插入图片描述](https://img.jbzj.com/file_images/article/202108/20210826165211149.jpg)

这样颜值检测的接口流程基本就已经清楚了，可以进行代码实现了。

其中获取token的时候，需要用到client_id 和 client_secret ，这两个就是上面创建人脸识别应用时提供的。

```

# 获取token
def get_token():
    # client_id 为官网获取的AK， client_secret 为官网获取的SK
    #host = 'https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=【官网获取的AK】&client_secret=【官网获取的SK】'
    host = 'https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=AbaIWY4rKccoMtvgGDF2GLQF&client_secret=BD5UCMxMS50bWbW7XabDIcMxPTxogdE5'
    response = requests.get(host)
    if response:
        # print(response.json())
        return response.json()['access_token']


# 颜值检测接口
def face_input(file_path):
    with open(file_path, 'rb') as file:
        data = base64.b64encode(file.read())
    img = data.decode()
    request_url = "https://aip.baidubce.com/rest/2.0/face/v3/detect"

    params = "{\"image\":\"%s\",\"image_type\":\"BASE64\",\"face_field\":\"beauty\"}" % img
    access_token = get_token()
    request_url = request_url + "?access_token=" + access_token
    headers = {'content-type': 'application/json'}
    response = requests.post(request_url, data=params, headers=headers)
    if response:
        beauty = response.json()['result']['face_list'][0]['beauty']
        # pprint.pprint(response.json())
        return beauty

path = 'DATA\颜值检测\img'
img_list = os.listdir(path)
# print(img_list)
score_dict ={}

for img in img_list:
    try:
        # 提取主播名字
        name = img.split('.')[0]
        # 构建图片路径
        img_path = path + '//' + img
        # 调用颜值检测接口
        face_score = face_input(img_path)
        # print(face_score)
        score_dict[name] = face_score
    except:
        print(f'正在检测{name}| 检测失败')
    else:
        print(f'正在检测{name}| \t\t 颜值打分为：{face_score}')

sorted_score = sorted(score_dict.items(), key=lambda x: x[1], reverse=True)
# print(sorted_score)

for i, j in enumerate(sorted_score):
    print(f'小姐姐名字是：{sorted_score[i][0]} | 颜值名次是：第{i+1}名 | 颜值分数是：{sorted_score[i][1]}')

```

可以看到result字段里面的beauty就是代表对小姐姐的颜值评分。效果如下：

![在这里插入图片描述](https://cdn.jsdelivr.net/gh/MuyanGit/pic_url@master/img/20210826165211150.jpg)

调用颜值检测接口已经写好了，下面我们要遍历之前保存的所有小姐姐直播照片，对每个进行颜值打分。

```

path = 'DATA\颜值检测\img'
img_list = os.listdir(path)
# print(img_list)
score_dict ={}

for img in img_list:
    try:
        # 提取主播名字
        name = img.split('.')[0]
        # 构建图片路径
        img_path = path + '//' + img
        # 调用颜值检测接口
        face_score = face_input(img_path)
        # print(face_score)
        score_dict[name] = face_score
    except:
        print(f'正在检测{name}| 检测失败')
    else:
        print(f'正在检测{name}| \t\t 颜值打分为：{face_score}')

sorted_score = sorted(score_dict.items(), key=lambda x: x[1], reverse=True)
# print(sorted_score)

for i, j in enumerate(sorted_score):
    print(f'小姐姐名字是：{sorted_score[i][0]} | 颜值名次是：第{i+1}名 | 颜值分数是：{sorted_score[i][1]}')

```

最后我们就只需要按照颜值分数进行降序排列，就可以选出颜值最高的小姐姐啦~

```
sorted_score ``=` `sorted``(score_dict.items(), key``=``lambda` `x: x[``1``], reverse``=``True``)``# print(sorted_score)` `for` `i, j ``in` `enumerate``(sorted_score):``  ``print``(f``'小姐姐名字是：{sorted_score[i][0]} | 颜值名次是：第{i+1}名 | 颜值分数是：{sorted_score[i][1]}'``)
```

通过颜值检测，这样就可以找到颜值最高的小姐姐了，颜值打分有90分以上。今天我们就到这里，明天继续努力！不说了，赶紧看直播去~

![在这里插入图片描述](https://img.jbzj.com/file_images/article/202108/20210826165211151.jpg)
![在这里插入图片描述](https://cdn.jsdelivr.net/gh/MuyanGit/pic_url@master/img/20210826165211152.jpg)

![在这里插入图片描述](https://cdn.jsdelivr.net/gh/MuyanGit/pic_url@master/img/20210826165211153.jpg)

如果本篇博客有任何错误，请批评指教，不胜感激 ！

到此这篇关于用python写个颜值评分器筛选最美主播的文章就介绍到这了,更多相关python颜值评分器内容请搜索脚本之家以前的文章或继续浏览下面的相关文章希望大家以后多多支持脚本之家！
