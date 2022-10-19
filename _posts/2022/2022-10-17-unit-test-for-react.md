---
layout: post
title: "Unit Testing in React.js"
description: ""
category: [software engineering]
tags: [other]
---

# React 的單元測試

## 前言 : 單元測試是什麼？

演示程式 : `src/utils/Validator/__test__/Validator.email.test.js`

```javascript
// 測試方法 isEmailAddress(txt:string) 運作正常

it('email 地址應該包含 @ 符號', () => {
  expect(Validator.isEmailAddress('joe_xxx.com')).toBe(false);
  expect(Validator.isEmailAddress('joe@xxx.com')).toBe(true);
});
```

## 前言 : 為什麼要做 Unit Test?

#### 長期確認功能正常

昨天開發的功能: 驗證 email 正確性  
今天有信心告訴 PM 沒問題  
經過半年團隊所有人修修改改，還有信心說 沒問題 嗎？

#### 活的說明文件

你接手一個前人開發的專案，  
也許有當初的需求文件，實際需求在開發過程中修修改改，  
PM 告訴你 : "最後上線的系統可能與需求文件有些不同，***你要小心喔***"
當實際系統演化逐漸脫離說明文件，說明文件就死了。

單元測試是初級的 [Living Documentation](https://johnfergusonsmart.com/living-documentation-not-just-test-reports/)

#### 軟體工程師的專業能力

單元測試幫助你更好地思考程式結構  
資深工程師的必備能力  
常見不想做單元測試的理由 : [Why I stopped testing my code 反諷](https://corebts.com/blog/why-i-stopped-testing-my-code/)

## 運行方式

#### Demo APP

- 下載 Demo APP : `git clone git@github.com:larrysu1115/react-unit-test-demo.git`
- 執行 `npm install`
- Demo APP 運行 : `npm start`
- Demo APP 功能

在 VS Code 中運行，需要設定好 `.vscode/launch.json`，  
可以設定斷點 Step by Step 執行 Debug

- 試著運行 : `src/components/LoginForm/__test__/LoginForm.submit.test.js`
- 可以加入斷點查看變數

在命令行用互動模式運行 : `npm run test`

在命令行運行單一測試檔案 : `npm test -- LoginForm.submit.test.js --watchAll=false`

在命令行運行測試，並獲得 test coverage 報告 : `npm test -- --watchAll=false --coverage `

## JavaScript 的單元測試 : Jest

JavaScript 的單元測試，以 [Jest](https://jestjs.io) 工具為主流。

- `src/utils/Validator/__test__/Validator.email.test.js`
- `src/utils/Validator/__test__/Validator.password.test.js`

## React 的單元測試 : React Testing Library

使用 [React Testing Library](React Testing Library) 為主流。  
在 'Jest' 的基礎上，開發的工具。  
[Testing Library](https://testing-library.com) 同時支援各種前端框架 (React / Vue / Angular...)，學一次就可以運用在許多不同前端框架！

#### 基本上是三種操作:

```
// Queries 找到元素
const loginButton = screen.getByRole('button');

// 模擬用戶操作 : 
const user = userEvent.setup();  // 初始化 userEvent
await user.click(loginButton);

// 驗證元素存在 :
expect(screen.getByText('登入成功')).toBeInTheDocument();
```

#### React Testing Library : Queries 找到元素

- 以使用者的角度，獲得 HTML 中元素來操作，[採用哪種Query方法的優先次序](https://testing-library.com/docs/queries/about#priority)
- ARIA 定義 HTML 元素 (Accessible Rich Internet Applications), [參考這裡](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/ARIA_Guides)
- 可以利用 screen.debug() 查看畫面的 HTML。舉例: `components/LoginForm/__test__/LoginForm.submit.test.js`

#### 模擬用戶操作

- 使用 [user-event](https://testing-library.com/docs/user-event/intro)
- 舉例: `components/LoginForm/__test__/LoginForm.submit.test.js`

## 測試用的 Mock 造假

#### 單元測試的常見名詞 / 概念

- SUT : System Under Test。目標要測試的元件/方法
- DOC : Depended-On Component。會依賴到的其他元件/方法
- [Mock 替身](https://medium.com/starbugs/unit-test-中的替身-搞不清楚的dummy-stub-spy-mock-fake-94be192d5c46)
- Mock 是使用 ***造假*** 的 依賴子元件/方法(DOC)。將測試關注的目標集中在元件本身(SUT)

#### 舉例

- 元件有依賴其他子元件，可以 Mock 子元件。例: `src/App.test.js`
- 元件有依賴其他方法，可以 Mock 方法。例: `src/components/LoginForm/__test__/LoginForm.submit.test.js`
- 元件依賴外部模組，也可以 Mock，如呼叫 axios 網路 API。例: `src/api/JokeApi/JokeApi.BAD.test.js`, `src/api/JokeApi/JokeApi.GOOD.test.js` 

## 優秀單元測試的特質

節錄自 ***單元測試的藝術***, page 7

```
- 它應該是自動化，可被重複執行的；
    > 什麼樣的測試是不能重複執行的？

- 它應該很容易被實現；
    > 容易實現，所以熟悉之後，會比手動測試更快速，開發時間更短
    > 我能在幾分鐘內寫出一個基本的單元測試嗎？

- 它到第二天應該還有存在意義；（不是臨時性的）

- 任何人都可以按個按鈕就執行；
    > 我兩個月前寫的單元測試，團隊所有人是否都能正常執行呢？

- 它的執行速度應該很快；
    > 單元測試日積月累，可能會有成千上萬個，部署前要運行所有單元測試，可能會很久。
    > 我能在幾分鐘內跑完所有單元測試嗎？

- 它的執行結果應該一致；
    > 方法 getWeekdayOfToday() 每天回傳結果都要一致。
```

[timer-mocks](https://jestjs.io/docs/timer-mocks)

## thinker F2E 現況

- 7 個單元測試。 App.test.js / Menu.test.js 嚴重依賴外部模組，子元件，呼叫網路API。
- 想要重構 Menu.js (3000 行)
- 先對 Menu.js 寫基本的測試（有許多依賴沒有解耦）
- 分離部份 function，為分離的 function 各別撰寫單元測試。
- 減少 Menu.js 的行數。希望減低到 500 行。
- 能夠對 Menu.js 撰寫乾淨沒有依賴的 單元測試
- “[most component files should not exceed 250 lines](https://medium.com/swlh/how-to-write-great-react-c4f23f2f3f4f)”, by Scott Domes, author of ***Progressive Web Apps with React***

## 單元測試的重要性

- 進行重構前的安全保護
- 2020 年工程師隨身必備
