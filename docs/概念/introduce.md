# 探索Server-driven UI

## SDUI是什么

SDUI 是近来讨论比较多的一个话题，在前半年的[TW技术雷达](https://www.thoughtworks.com/radar/techniques/server-driven-ui)中我们有看到它。我也在SmartThing CoE组织的社区活动中和很多同事有过探讨和分享。我想借这篇文章，用文字的形式介绍下SDUI的来龙去脉，并提出我的SDUI particle模型和各位一起讨论。

Server-driven UI (or Backend driven UI) 顾名思义，服务端驱动客户端的UI展示，在`everything being done client side`之外提供了一种UI实现思路。

从我找到的一些资料看，2016年的时候Spotify已经在做这样的事情。Spotify作为音乐流媒体服务，经常需要围绕播放列表做一些UI尝试，所以SDUI架构让他们的播放列表相关的一系列UI组件进行快速修改。这是找到的Spotify Android Dev的一个[演讲视频](https://www.youtube.com/watch?v=vuCfKjOwZdU&feature=youtu.be)，非常精彩。

当然，Spotify不是个例，我在这个[Github讨论帖](https://github.com/MobileNativeFoundation/discussions/discussions/47)中看到 `Molotov.tv`, `Airbnb`,`Lyft`等等, 甚至`REA Group`(我们的客户)，他们比较细致且总结性的描述了各自在公司(或项目)上对SDUI的实践。你从中可以感受到他们为之付出的探索和热情。

我想在这个章节从两个角度来思考SDUI的产生和演进。

### 代码快速产品化，并少一些事故
我们知道，移动应用一直存在版本控制问题，并不是所有用户总会(或者第一时间会)更新他们的应用程序。

常见的开发团队，在交付成熟以后，基本上每个迭代都会往市场推送应用更新，也就是每两周或者每个月一次的频率。我们为此付出了很多努力，我们投入资源，我们改进流程，只是为了快速迭代更新。但这个时候我们还是有两个问题需要思考。`1. 用户明天能升级到最新版本吗`，`2. 我们能在做完测试后后直接部署吗`。

如果我们有一套系统，假设客户端支持服务端给的响应，我们的代码一旦合入Master分支，用户立即就能体验到新版本，这个新版本可能是做了一些新特性，也可能是回退了代码。总之，它快速的解决了用户和PO的需求。

在事故(或bug)层面，不仅仅是我上一段提到的回退代码来解决用户问题。如果线上事故来源于信息（需求，方案等）的传递，比如对信息的理解不一致（我要澄清的是，某个角色对信息的理解可能出现错误，但是几个角色理解不一致出错的概率更大），那我希望这套系统能更智能一些--iOS，Android，Web的业务逻辑在一端控制。这个系统不能避免错误，但可以让逻辑在一个端输入。

### 控制尽量精细化，并有原生体验
在我描述完上一段后，脑海里可能出现了一个场景，这个系统不就是这样吗---我们在浏览器输入“www.baidu.com”, 它将展示什么页面，服务端完全控制。是的，这就SDUI，但不完全是。

移动应用的页面有的简单，有的复杂，绘制和业务逻辑就在我们写的代码中。如果今天优化的页面层级，明天可能就会优化页面的跳转逻辑，有时候，文字加粗，变色也会被提出来。但是，这些远远不是最细小的细节。从某个层面（~~追求~~）来说，SDUI控制更精细度似乎可以证明自己更强大。

我们知道移动平台提供了很多框架，很多API，还有很多的努力，致力于改进用户使用应用的体验，点击，滑动，跳转，它们变得越来越有趣和丝滑。假如我们在整个Application中提供一个WebView加一个Root URL，显然它是没有太大意义的-- 浏览器做的更好。

这就是SDUI的选择，也是SDUI的演进，它徘徊在HTML和CDUI之间。

![SDUI-progress](https://raw.githubusercontent.com/server-control/SDUI-res/main/SDUI-Imp.jpg)
CDUI是传统上构建移动或前端应用程序的方式，客户端知道并能决定如何构建用户界面。
HTML是作为服务器驱动 UI 的极端版本​​，服务器控制一切。
BFF 客户端做出大部分决策，服务端会有一些对于API级别的控制。
Toggle 基本上保证了原生的体验，可以用于一些feature级别的控制。
Particle模型中，服务器描述了 UI 的表现、变化行为，并在一定的颗粒度上来描述，它了解全部的业务。同时，它也有接近CDUI的原生体验。

### 所以，它是什么
SDUI是一个领域术语，它的意思是服务器来驱动用户界面的呈现。
SDUI是一个解决方案，它可以实现一些常见（特殊）的软件需求。
SDUI是一个描述语言，它定义了服务器和客户端的合作方式（包括细节）。

服务端驱动UI的背后，也驱动了需求落地，驱动了业务迭代。显然在这个系统下，产品的决策将更容易。

## Particle 模型介绍
[粒子（particle）](https://baike.baidu.com/item/%E7%B2%92%E5%AD%90/81757)，是指能够以自由状态存在的最小物质组成部分。最早发现的粒子是原子、电子和质子，1932年又发现中子，确认原子由电子、质子和中子组成，它们比起原子来是更为基本的物质组分，于是称之为基本粒子。以后这类粒子发现越来越多，累计已超过几百种，且还有不断增多的趋势；此外这些粒子中有些粒子迄今的实验尚未发现其有内部结构，有些粒子实验显示具有明显的内部结构。看来这些粒子并不属于同一层次，因此基本粒子一词已成为历史，如今统称为粒子。粒子并不是像中子、质子等实际存在的具体的物质，而是它们的统称，是一种模型理念。
从来自百科的描述中，我们了解到科学家在尝试找到粒子的尽头，即发现不可拆解的最小个体。而且他们一直在路上，随着技术的进步，认知的变化，实验室总是有更小的粒子出现。

再看看一个应用的组成，或许我们可以更简单一些，观察一个显示在屏幕上的页面的组成。
![wechat-screen](https://raw.githubusercontent.com/server-control/SDUI-res/main/wechat-screen.jpg)
如果拆解这个页面，可以看到顶部的状态栏，未读消息个数，搜索图标，添加好友图标。中间是一个对话列表。我想在底部应该还有一个导航Tab。这些都是UI元素，如果仔细看，还有一些未读消息的小红点，点了那个消息，我相信回到列表时红色点会消失--很简单的逻辑。你可能进一步看到了TextView，Image，Icon等开发组件。
当然页面上还有一些交互，我们可以滑动这个列表查看更多，也可以点击添加好友的图标，还可以双击顶部栏回到列表最顶部。

抽象一下它，整个页面上包只包含了多个图形单元 + 行为单元。图形单元组成了呈现在眼前画面，行为单元可以按照用户的操作执行对应的图形变化。由于行为要在图形上操作，操作后的响应也是图形的重组。那行为是否可以属于图形？
particle并没有这么做，我期望的行为单元不只是用户在界面上的操作，比如点击和长按。它还应该包含非图形触发的行为，非图形重组的行为结果。
比如在上面的图片中，当应用收到websocket推送来的一条新消息，应用需要发送请求到服务端获取这条消息的内容。是的，这也在particle的控制范围，也就是说，应用收到websocket推送来的一条新消息时，业务的逻辑不一定是（虽然现在是）“需要发送请求到服务端获取这条消息的内容”，particle可以在服务端控制它，随时可以改成“应用收到websocket推送来的一条新消息时，弹出一个让用户确认的对话框”。particle模型中，这种变化不需要客户端做任何改动。

所以用particle模型来描述SDUI，它便是，**在当前认知范围内，一套不可拆分的图形单元和行为单元组成的应用构建系统。** 其中的认知，是SDUI系统构建者的决定，利用这些基本单元制造（组合）的富单元也属于系统的一部分。

### 举个例子
关于认知和不可拆分。我说一架钢琴是不可拆分的，可能有很多人不理解，但是我说一分钱不可拆分，赞同的人可能会稍微多一些。钢琴和一分钱就在那里，我们很少去纠结钢琴的88个键为什么黑键36个，白键52个。我们也很少尝试去把`Text`这个组件，`Click`这个动作再去拆解，这些我在实现particle的时候去展开。

关于粒子组合。如果C(碳元素)和O(氧元素)是最基本的单元，那么一氧化碳和二氧化碳就是它们组合的富单元。当然，一氧化碳和二氧化碳如果可以拿来做其他的事情就更好了。总之，组合粒子的目的是为了不做重复的事情。

## Particle 设计和实现
有了上面的SDUI和Particle的介绍，Particle系统应该可以顺利的被设计出来。但是在这之前，我想重申下前面已经提到的原则。这些原则不能轻易被破坏，否则系统可能会倒塌。
1、不要让客户端知道业务逻辑。
2、尝试重组，不要重复自己。 

![particle-cs](https://raw.githubusercontent.com/server-control/SDUI-res/main/particle-cs.jpg)
Particle系统是CS结构。客户端接入一个library或者module，library提供的API只有Init。基于上面的原则1，客户端不应该知道任何逻辑，它自然不能调用其他API。Particle的服务端按需接入其他服务，以便为客户端实现业务（~~控制客户端~~）。
提供给客户端library，需要实现所有的Particle系统中的图形(富)单元和行为(富)单元。这样做可以保证客户端能“认识”服务端所有的响应。

### 基本单元

整个系统的的基本单元我也叫它particle，在上面的介绍中我提到，`基本构建单元= 图形单元+行为单元`。因此可以这样为它建模(我用kotlin语言写的，我会在后面的传输章节中提及这一点，用Protobuf建模是个好选择)。`id`是Particle的标识，`actions`是行为单元，`modifier`是图形单元的的修饰器，后面就是图形单元，一个基本构建单元只能包含一个图形单元。
```
data class Particle(
    var id: String,
    var actions: MutableList<Action> = mutableListOf(),

    var modifier: Modifier? = null,

    var horizontalStack: HorizontalStack? = null,
    var verticalStack: VerticalStack? = null,
    var textView: TextView? = null,
    var button: Button? = null,
    var textField: TextField? = null,
    var icon: Icon? = null,
    ...
    ...
)
```
### 图形单元

[Flexbox弹性盒子](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)和[materia design材料设计](https://m3.material.io/)为我提供了如何描述图形界面和Particle图形单元设计的灵感。
![flexbox](https://raw.githubusercontent.com/server-control/SDUI-res/main/particle-box-mode.jpg)
盒子模型中的content是被我设计成了Particle图形单元内容，它可以是Button, Devider, Checkbox。 对内容的修饰的padding, border, width, height我用modifier定义它。看着似曾相识的感觉，是的，现在的移动端大多已经有了这样的UI框架。
如前文的介绍，SDUI是一种描述语言，我们必须为服务端和客户端定义一种图形的数据形式表达。而从Flexbox入手来设计对于SDUI的开发者和使用者来说更简单一些，因为我想屏蔽iOS，web，Android开发者的技术栈，让任何人都可以快速的开始。
还有一点，[Jetpack compose ](https://developer.android.com/jetpack/compose) 和[SwiftUI](https://developer.apple.com/xcode/swiftui/)对SDUI的推动是很大的。声明式UI下，state一旦变化会立即触发UI的刷新。这正是Particle模型需要的，包括下面将提到的行为单元中，也是如此。

### 行为单元
行为单元的设计在Particle模型中是这样的，所有的行为都被抽象成了两部分 trigger 和 effet。而trigger和effect本身也是独立的，它们可以任意组合。甚至我把它设计成了一对多的组合，因为一个trigger的确可能产生多个影响。

理解它可以从 [redux reducer](https://www.redux.org.cn/docs/basics/Reducers.html)入手。下面是一个简单的action例子，如果把这个action和一个Button的图形单元被一起放在Particle中，那么它将被理解成`点击按钮时，需要改变一个标识为id1的particle中的图形单元背景为Color_1`
```
Action(
    trigger = Trigger.CLICK, effects = mutableListOf(
        Effect(
            ChangeModifierEffect(
                target = Target(id = "id1"),
                 modifier = Modifier(backgroundColor = ColorToken.COLOR_1)
           )
        )
  )
)
```
这里也要提到一点，页面的导航，整个应用不可能只有一个页面，我们经常在不同的屏幕之间跳转。这需要行为和图形设计一起完成，我为此花费了很多思考，或许单独再讨论。当然大多数的为了页面变化而设计的Effect都需要关注图形的实现。

### 数据传输
性能是一个系统无法避开的话题，在这个章节我可以尝试说明下客户端和服务端的传输。传统CDUI的应用会把UI和数据分开，页面用什么组件渲染是按照设计稿完成，当需要为页面的做表单请求，数据加载的操作时，客户端会和服务端有数据传输。
在particle系统中，整个应用的控制都在服务端控制，UI如何绘制，会触发什么效果，所有以的数据都需要从服务端响应，这是一个挑战。
比如，系统建模，我们应该做到只传输有效的数据到客户端。数据的序列化和反序列化，需要考虑数据压缩比，还有解析时的成本。[protocol-buffers)](https://developers.google.com/protocol-buffers)是 Google 提供的序列化，结构化数据解决方案，它语言中立、平台中立、可扩展，相比XML，Json，但更小、更快、更简单。它是为particle数据建模，传输的好选择。

## 从Particle再回到SDUI
通过对Particle的介绍，我想再讨论一下SDUI在工程实践中的实用性，以及如何使用。
SDUI从2016(可能更早)年被运用在商业应用中，到近期声明式UI的出现对其推动，可以肯定它完全可用。而且我了解到的是很多的项目在全量使用或者局部使用它，当你在项目中恰好有一些痛点和SDUI的初衷不谋而合时，采用它将是个好选择。

如何使用SDUI，我想举个Particle中shadow的例子，或许你能有一些答案。
如果我们想为一个图形单元(比如Button)设计一个由服务端控制的shadow，我们需要怎么做呢。
![particle-shadow](https://raw.githubusercontent.com/server-control/SDUI-res/main/particle-shadow.jpg)
光从哪里来，有几个光源，角度等，[CSS box-shadow](https://developer.mozilla.org/zh-CN/docs/Web/CSS/box-shadow)的是这样定义的，这是一个很好的模型，在客户端也可以画出来它定义的属性，服务端也可以精细的控制阴影。

单还有一种可能，我在们SDUI中定义5种Shadow，客户端也预设5种Shadow，这就是5个token，当服务端想给某个图形加阴影修饰的时候，发送对应token到客户端即可。选择更少一些又有什大的问题呢。
这只是一个例子，我想这样的场景还有很多。
```
enum class Shadow {
    DEFAULT, SHADOW1, SHADOW2, SHADOW3, SHADOW4
}
```
Shadow的使用如此，SDUI的使用也如此。


## 参考资料

https://css-tricks.com/snippets/css/a-guide-to-flexbox/
https://m3.material.io/
https://baike.baidu.com/item/%E7%B2%92%E5%AD%90/81757
https://www.youtube.com/watch?v=vuCfKjOwZdU&feature=youtu.be
https://github.com/MobileNativeFoundation/discussions/discussions/47
https://developers.google.com/protocol-buffers
https://developer.mozilla.org/zh-CN/docs/Web/CSS/box-shadow