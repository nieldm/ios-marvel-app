# JustHeroes

###### and some Villans

This an App exercise using the Marvel API that will show the character from marvel, with sort and search options, you can navigate into each character, to view the comics,  and also you can go to the comic detail.

<img title="" src="file:///Users/nieldm/Winterfell/jobs_test/ios-marvel-app/images/logo.png" alt="" data-align="inline">

## UI

<img src="file:///Users/nieldm/Winterfell/jobs_test/ios-marvel-app/images/darkHome.png" title="" alt="" width="179"><img title="" src="file:///Users/nieldm/Winterfell/jobs_test/ios-marvel-app/images/lightHome.png" alt="" width="178">

The UI is simple, you can find both options light and dark, this levarage the use of color inside the assets.

## Build

This app is built **Xcode 11.5** and **Swift 5.0**

A **pod install** and ⌘+R will do the trick.

#### Enviroment Variables

You can pass this variable to modify the behavior of the app

- START_VIEW = [test | characterList | sortFilter | comics | none] : this will be used to change the first view the app will load.

- MARVEL_API_KEY = String

- MARVEL_PRIVATE_KEY = String

- MOCK_SERVER = [YES | NO] 

## Test

The app contains a small set of test (i will like to increase the coverage) each one of the test was used at development time to increase the speed of the feedback.

Data provided by Marvel. © 2020 MARVEL

## Features

### CollectionViewKit

This library was built for this app, to simplofy the implemetation of the collection view, reducing the boileplate code.

You will need to provide 2 classes based on the **CollectionViewSection** and the **CollectionViewItem**

Then on this you can create a **CollectionViewDataSource** and **CollectionViewDelegate** to be passed to a **CollectionViewController**

With this the **BaseListCollectionViewController** was created, with the idea to use a single model (**BaseModel**) to represent the information on the app.

### SortAndFilterViewController

The approach was to build the sort and filter, agnostic of the data that is being affected, it's a view controller, that you will add as a child and cominicate with it via **SortAndFilterViewModelOutput**

### Network

It's all based on **URLSession** with the **BaseAPIProtocol** you will need to implent 2 fetch methods, this approach takes sense we you see the **MockedBaseAPI** that will use json to prevent hits on the API for tests and a faster Development Cycle.

### Assembler

Here you can find the resolution of the depencies of each of the modules of the app. The idea is to have a single place to see how each module it's built, in a larger app this can be separated on different files, something like one per module.

### ImageRepository

This one is in charge of getting all the images, it uses a **ImageRepositoryProtocol** so it can be mocked, also implements **Cache** in a simple way using **URLCache** also has a method of **downsampleImage** the idea of this method is to match the size of the element that the image will be presented, so it performs better since the image will be smaller.

### BaseRepository

all the external data it's requested via this repository, that will use an interchangeable **DataSources** like it's done with the **MarverlComicsDataSource** and **MarverlCharacterDataSource** each one will use a different mapper to create a **BaseModel**.

## MissingNo.

there is a lot to improve in a quick project like this one, this are some things i will like to improve:

- Animations

- Better dependency injection

- Improve the test coverage

- Implement a generic approach to the UITest to reflect the intention of the tests more easly

- Improved UI
