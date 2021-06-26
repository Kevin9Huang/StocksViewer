# StocksViewer

## Description

StocksViewer is a simple project app that display crypto coin price and coin news associated with the coin.

## Project Overview

<p float="left" align="middle">
  <img src="/Screenshot/projectView1.png" width = "257" height = "556" hspace="10"/>
  <img src="/Screenshot/projectView2.png" width = "257" height = "556" hspace="10"/> 
  <img src="/Screenshot/projectView3.png" width = "257" height = "556" hspace="10"/>
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

3. Get your API KEY from [here](https://min-api.cryptocompare.com/documentation/websockets). Place the API Key on WebSocketManager.swift
Note: Maske sure to check the *Read All Price Streaming and Polling Endpoints*

## Dependencies
* [Starscream](https://github.com/daltoniam/Starscream) WebSocket API Library

## APIs
* Fetch coins [link](https://min-api.cryptocompare.com/data/top/totaltoptiervolfull?limit=50&tsym=USD&ascending=false)
* Fetch news [link](https://min-api.cryptocompare.com/data/v2/news/?lang=EN&excludeCategories=Sponsored)
* Web Socket End points : wss://streamer.cryptocompare.com/v2

## Further Improvement

### App Improvement
1. Add more comment for documentation
2. Add no results view/label when no coin models
3. Change UIAlertController to more user-friendly interactive when failed/notified
4. Add reload button when error of no network connection
5. Add UIBarButtonItem at the top right side of StocksViewController to enable searching for a specific coin
6. Add UIButton to toogle sort ascending/descending by coin price/coin name
7. Add UIImage to StocksTableViewCell to display coin image
8. Add animation when price goes up/down while changing background color (red/green)

### Unit Test
1. Add more test case on StocksViewerViewModel expecially on unhappy path.
2. Stub API/WebSocket with mock to test network error and failure case (unhappy path)

## Authors

Kevin Huang

[@Kevin9Huang](https://github.com/Kevin9Huang)

## License

N/A
