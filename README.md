# ToDoList-Redux
Topic : Redux based ToDo / Task application

## Objectives
Lately I have been looking at migrating part of the code from the application I am developing from UIKit to SwiftUI. While the pure transition from UIKit to SwiftUI was actually pretty smooth in my first tribulation, the [architectural framework](https://github.com/DeclarativeHub/TheBinderArchitecture) I am using for UIKit, just [doesn't seem to fit](https://github.com/DeclarativeHub/TheBinderArchitecture/issues/10) very well to SwiftUI. This led me on a wild-goose chase for other, more suited, framework for SwiftUI.

### Enters Redux
While on my search I came across [Redux](https://redux.js.org) (deja vu ?) and more specifically [SwiftRex](https://github.com/SwiftRex/SwiftRex). There are a ton of other Redux frameworks for Swift out there, but SwiftRex seemed to line up pretty well with what I was looking for, and its creator, [@luizmb](https://github.com/luizmb), was super responsive and very helpful in getting me started.

### ToDo / Task application

As I was going through the evaluation of the different Swift Redux frameworks, I saw numerous "Counter" examples. This seems like the "Hello World !" equivalent for Redux. However it's really not nearly enough to get a decent feel for how well it will suit one's needs.

So I used a fairly basic Task application to compare those different Swift Redux framework. I initially started reading about [how to model app state using Store object](https://swiftwithmajid.com/2019/09/04/modeling-app-state-using-store-objects-in-swiftui/) using `ObservableObject`. Thanks to some really good reading from [Peter Friese](https://peterfriese.dev/replicating-reminder-swiftui-firebase-part1/) and [Majid Jabrayilov](https://swiftwithmajid.com/2019/07/31/introducing-container-views-in-swiftui/), I settled on a design for the initial Task application (read those links if you want to learn more about the different designs).

## Iterations

### 1. Container / Render View [(swiftrex-option1b)](https://github.com/npvisual/ToDoList-Redux/tree/swiftrex-option1b)

The first approach is based on a very light introduction of Redux and SwiftRex concepts : 

* it uses Combine's [`@StateObject`](https://github.com/npvisual/ToDoList-Redux/blob/96d705993b02318989045aa95dfd8534c1ff46ca/ToDoList-Redux/ToDoList_ReduxApp.swift#L18) and [`@ObservedObject`](https://github.com/npvisual/ToDoList-Redux/blob/96d705993b02318989045aa95dfd8534c1ff46ca/ToDoList-Redux/Views/TaskList.swift#L13) to "link" with SwiftRex's [`ObservableViewModel`](https://github.com/SwiftRex/SwiftRex/blob/develop/Sources/CombineRex/ObservableViewModel.swift). This is (roughly) how you [pass down Redux's Store](https://github.com/npvisual/ToDoList-Redux/blob/96d705993b02318989045aa95dfd8534c1ff46ca/ToDoList-Redux/Views/TaskList.swift#L19) (or projections of the Store) to your Views,
* it shows how to [create the Store](https://github.com/npvisual/ToDoList-Redux/blob/96d705993b02318989045aa95dfd8534c1ff46ca/ToDoList-Redux/ToDoList_ReduxApp.swift#L15) early on in your app,
* it demonstrates how to [bind](https://github.com/npvisual/ToDoList-Redux/blob/96d705993b02318989045aa95dfd8534c1ff46ca/ToDoList-Redux/Views/TaskList.swift#L20) the State and Actions to a regular SwiftUI view.
* it gives an [example](https://github.com/npvisual/ToDoList-Redux/blob/96d705993b02318989045aa95dfd8534c1ff46ca/ToDoList-Redux/Views/TaskList.swift#L64) of how Previews can be achieved with SwiftRex.

You can find some great explanations from Luis [here](https://github.com/SwiftRex/SwiftRex/issues/67#issuecomment-669599677) on the different possible approaches I was going after.

However, while this was a good first step toward what Luis described as "Option 1b", it still wasn't making much use of the Redux framework since it was directly tying the cell view into the ForEach of the TaskList.


https://peterfriese.dev/replicating-reminder-swiftui-firebase-part1/
https://swiftwithmajid.com/2019/09/04/modeling-app-state-using-store-objects-in-swiftui/
https://swiftwithmajid.com/2019/07/31/introducing-container-views-in-swiftui/
https://swiftwithmajid.com/2019/09/25/redux-like-state-container-in-swiftui-part2/
https://swiftwithmajid.com/2019/10/02/redux-like-state-container-in-swiftui-part3/
