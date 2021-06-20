# StocksViewer

## Description

StocksViewer is a simple project app that display crypto coin price and coin news associated with the coin.

## Project Overview

<p float="left" align="middle">
  <img src="/Screenshot/projectView1.png" width = "257" height = "556" hspace="20"/>
  <img src="/Screenshot/projectView2.png" width = "257" height = "556" hspace="20"/> 
  <img src="/Screenshot/projectView3.png" width = "257" height = "556" hspace="20"/>
</p>

From the left side:
1. StocksViewerViewController
2. NewsViewController
3. Project Structure

## Getting Started

### Prerequisite
1. Installed CocoaPods
```
sudo gem install cocoapods
```
2. Install dependencies from Podfile
```
pod install
```

## Dependencies
* [Starscream](https://github.com/daltoniam/Starscream) WebSocket API Library

## APIs
* Fetch coins [link](https://min-api.cryptocompare.com/data/top/totaltoptiervolfull?limit=50&tsym=USD&ascending=false)
* Fetch news [link](https://min-api.cryptocompare.com/data/v2/news/?lang=EN&excludeCategories=Sponsored)
* Web Socket End points : wss://streamer.cryptocompare.com/v2

## Authors

Kevin Huang

[@Kevin9Huang](https://github.com/Kevin9Huang)

## License

N/A
