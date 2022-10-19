---
layout: post
title: "Unit Testing in React.js"
description: ""
category: [software engineering]
tags: [other]
---

# React 的單元測試

- 為什麼要做 Unit Test?
- 好的單元測試

# 準備

- 下載 Demo APP : `git clone git@github.com:larrysu1115/react-unit-test-demo.git`
- 執行 `npm install`

# 前言 : 單元測試是什麼？

演示程式 : `src/utils/Validator/__test__/Validator.email.test.js`

```javascript
// 測試方法 isEmailAddress(txt:string) 運作正常

it('email 地址應該包含 @ 符號', () => {
  expect(Validator.isEmailAddress('joe_xxx.com')).toBe(false);
  expect(Validator.isEmailAddress('joe@xxx.com')).toBe(true);
});
```

# 前言 : 為什麼要做 Unit Test?

## 長期確認功能正常

昨天開發的功能: 驗證 email 正確性  
今天有信心告訴 PM 沒問題  
經過半年團隊所有人修修改改，還有信心說 沒問題 嗎？

---

## 活的說明文件

你接手一個前人開發的專案，  
也許有當初的需求文件，實際需求在開發過程中修修改改，  
PM 告訴你 : "最後上線的系統可能與需求文件有些不同，***你要小心喔***"
當實際系統演化逐漸脫離說明文件，說明文件就死了。

單元測試是初級的 [Living Documentation](https://johnfergusonsmart.com/living-documentation-not-just-test-reports/)

---

## 軟體工程師的專業能力

單元測試幫助你更好地思考程式結構  
資深工程師的必備能力  
常見不想做單元測試的理由 : [Why I stopped testing my code 反諷](https://corebts.com/blog/why-i-stopped-testing-my-code/)

# React 單元測試

- Demo APP 運行 : `npm start`
- Demo APP 功能

---

## 運行方式

在 VS Code 中運行，需要設定好 `.vscode/launch.json`，  
可以設定斷點 Step by Step 執行 Debug

- 試著運行 : `src/components/LoginForm/__test__/LoginForm.submit.test.js`
- 可以加入斷點查看變數

在命令行用互動模式運行 : `npm run test`

在命令行運行單一測試檔案 : `npm test -- LoginForm.submit.test.js --watchAll=false`

在命令行運行測試，並獲得 test coverage 報告 : `npm test -- --watchAll=false --coverage `

# JavaScript 的單元測試 : Jest

JavaScript 的單元測試，以 [Jest](https://jestjs.io) 工具為主流。

- `src/utils/Validator/__test__/Validator.email.test.js`
- `src/utils/Validator/__test__/Validator.password.test.js`

# React 的單元測試 : React Testing Library

使用 [React Testing Library](React Testing Library) 為主流。  
在 'Jest' 的基礎上，開發的工具。  
[Testing Library](https://testing-library.com) 同時支援各種前端框架 (React / Vue / Angular...)，學一次就可以運用在許多不同前端框架！

## 基本上是三種操作:

```
// Queries 找到元素
const loginButton = screen.getByRole('button');

// 模擬用戶操作 : 
const user = userEvent.setup();  // 初始化 userEvent
await user.click(loginButton);

// 驗證元素存在 :
expect(screen.getByText('登入成功')).toBeInTheDocument();
```

## React Testing Library : Queries 找到元素

- 以使用者的角度，獲得 HTML 中元素來操作，[採用哪種Query方法的優先次序](https://testing-library.com/docs/queries/about#priority)
- ARIA (Accessible Rich Internet Applications), [參考這裡](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/ARIA_Guides)

## 模擬用戶操作

- [user-event](https://testing-library.com/docs/user-event/intro)

