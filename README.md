# Project Description (English translation of the Chinese section)

This repository is a Flutter demo application (Union Shop) implemented for coursework. The goal is to reproduce most of the features of an online shop for demonstration and assessment, with emphasis on functionality and responsive layouts.

## Implemented features (brief)

- Static homepage (mobile-first)
- Responsive navigation (mobile / desktop)
- About page (static)
- Footer with example links
- Collections list and single collection page (data-driven)
- Product detail pages (images, variants, add-to-cart)
- Sale/Promotions page
- Authentication UI (example sign-in / sign-up forms)
- Shopping cart (add items, change quantity, persistence via SharedPreferences)
- Search results page
- Print Shack personalisation demo page

## Run & Test (English)

Install dependencies and run the app:

```powershell
flutter pub get
flutter run    # or specify device: flutter run -d chrome / -d windows
```

Run tests:

```powershell
flutter test
```

## Continuous Integration (CI) (English)

The repository includes a GitHub Actions workflow `.github/workflows/ci.yml` that runs on push/PR and performs `flutter pub get`, `flutter analyze`, and `flutter test` for automated checks.

## Marking mapping (brief, English)

- Application (30%): Most basic and intermediate features are implemented (estimated ~27/30).
- Software development practices (25%): More tests, a clearer commit history and evidence of external service integration are needed (estimated ~7/25).

# Union Shop — Flutter Coursework

This repository contains the coursework project for students enrolled in the **Programming Applications and Programming Languages (M30235)** and **User Experience Design and Implementation (M32605)** modules at the University of Portsmouth.

## Overview

The Student Union has an e-commerce website, which you can access via this link: [shop.upsu.net](https://shop.upsu.net)

In short, your task is to recreate the same website using Flutter. You must not start from scratch, as you need to begin by forking the GitHub repository that contains the incomplete code. [The getting started section of this document](#getting-started) will explain more. Once you have completed the application, you will submit the link to your forked repository on Moodle for assessment and demonstrate your application in a practical session. See the [submission](#submission) and [demonstration](#demonstration) sections for more information.

⚠️ The UPSU.net link on the navbar of the union website is a link to an external site. This is not part of the application that you need to develop. So ignore the link highlighted below:

![Union Shop Header](https://raw.githubusercontent.com/manighahrmani/sandwich_shop/refs/heads/main/images/screenshot_union_site_header.png)

## Getting Started

### Prerequisites

You have three options for your development environment:

1. **Firebase Studio** (browser-based, no installation required)
2. **University Windows computers** (via AppsAnywhere)
3. **Personal computer** (Windows or macOS)

Below is a quick guide for each option. For more information, you can refer to [Worksheet 0 — Introduction to Dart, Git and GitHub](https://manighahrmani.github.io/sandwich_shop/worksheet-0.html) and [Worksheet 1 — Introduction to Flutter](https://manighahrmani.github.io/sandwich_shop/worksheet-1.html).

**Firebase Studio:**

- Access [idx.google.com](https://idx.google.com) with a personal Google account
- Create a new Flutter Workspace (choose the Flutter template in the "Start coding an app" section)
- Once the Flutter Workspace is created, open the integrated terminal (View → Terminal) and link this project to your forked GitHub repository by running the following commands (replace `YOUR-USERNAME` in the URL):

  ```bash
  rm -rf .git && git init && git remote add origin https://github.com/YOUR-USERNAME/union_shop.git && git fetch origin && git reset --hard origin/main
  ```

  This command should remove the existing Git history, initialize a new Git repository, add your forked repository as the remote named `origin`, fetch the data from it, and reset the local files to match the `main` branch of your forked repository. After running the above commands, open the Source Control view in Visual Studio Code and commit any local changes. This will create a commit that points to your forked repository. In the terminal you can push the commit to GitHub with:

  ```bash
  git push -u origin main
  ```

  If you're unsure that you're connected to the correct repository, check the remote with:

  ```bash
  git remote -v
  ```

  This should show the URL of your forked repository (`https://github.com/YOUR-USERNAME/union_shop.git` where `YOUR-USERNAME` is your GitHub username).

**University Computers:**

- Open [AppsAnywhere](https://appsanywhere.port.ac.uk/sso) and launch the following in the given order:
  - Git
  - Flutter And Dart SDK
  - Visual Studio Code

**Personal Windows Computer:**

- Install [Chocolatey package manager](https://chocolatey.org/install)
- Run in PowerShell (as Administrator):

  ```bash
| Dummy* Collection Page | Page displaying products within one collection including dropdowns and filters (hardcoded data* acceptable, widgets do not have to function) | 5% | [Collection Example](https://shop.upsu.net/collections/autumn-favourites) |
| Dummy* Product Page | Product page showing details and images with dropdowns, buttons and widgets (hardcoded data* acceptable, widgets do not have to function) | 4% | [Product Example](https://shop.upsu.net/collections/autumn-favourites/products/classic-sweatshirt-1) |
| Sale Collection | Page showing sale products with discounted prices and promotional messaging (hardcoded data* acceptable, widgets do not have to function) | 4% | [Sale Items](https://shop.upsu.net/collections/sale-items) |
| Authentication UI | Login/signup page with the relevant forms (widgets do not have to function) | 3% | [Sign In](https://shop.upsu.net/account/login) |
| **Intermediate (35%)** | | | |
| Navigation | Full navigation across all pages; users should be able to navigate using buttons, navbar, and URLs | 3% | All pages |
| Dynamic Collections Page | Collections page populated from data models or services with functioning sorting, filtering, pagination widgets | 6% | [Collections](https://shop.upsu.net/collections/) |
| Dynamic Collection Page | Product listings of a collection populated from data models or services with functioning sorting, filtering, pagination widgets | 6% | [Collection Example](https://shop.upsu.net/collections/autumn-favourites) |
| Functional Product Pages | Product pages populated from data models or services with functioning dropdowns and counters (add to cart buttons do not have to work yet) | 6% | [Product Example](https://shop.upsu.net/collections/autumn-favourites/products/classic-sweatshirt-1) |
| Shopping Cart | Add items to cart, view cart page, basic cart functionality (checkout buttons should place order without real monetary transactions) | 6% | [Cart](https://shop.upsu.net/cart) |
| Print Shack | Text personalisation page with associated about page, the form must dynamically update based on selected fields | 3% | [Personalisation](https://shop.upsu.net/products/personalise-text) |
| Responsiveness* | The layout of the application should be adaptive and the application should function on desktop in addition to mobile view (no need to test it on real devices) | 5% | All pages |
| **Advanced (25%)** | | | |
| Authentication System | Full user authentication and account management (you can implement this with other external authentications like Google, not just Shop), includes the account dashboard and all relevant functionality | 8% | [Account](https://shop.upsu.net/account) |
| Cart Management | Full cart functionality including quantity editing/removal, price calculations and persistence | 6% | [Cart](https://shop.upsu.net/cart) |
| Search System | Complete search functionality (search buttons should function on the navbar and the footer) | 4% | [Search](https://shop.upsu.net/search) |

Below are explanations for some of the terminology used in the table:

***Pages** refer to distinct screens or views in your application that users can navigate to. See [line 22 of `lib/main.dart`](https://github.com/manighahrmani/union_shop/blob/main/lib/main.dart#L22) or the `navigateToProduct` function in the same file for an example of how to define routes for different pages.

***Hardcoded data** refers to data (text or images) that is directly written into your code files rather than being fetched from a database or external service. For example, you can create a list of products with an AI-generated image and text descriptions directly in your Dart code instead of retrieving them from a backend.

***Dummy data** is data that is often hardcoded or (AI) generated for display or testing purposes. It is not meant to represent real-world data stored in your services.

***Responsiveness** refers to the ability of your application to adapt its layout and design based on the screen size and orientation of the device it is being viewed on. Your app should primarily focus on mobile view but to achieve full marks in this section, it should also function correctly on wider screens (desktop view).

### Software Development Practices

In addition to functionality, you will be assessed on your software development practices demonstrated throughout the project (worth 25% of the coursework mark). These marks are awarded after the demo based on evidence in your repository.

The table below outlines the aspects that will be evaluated and the mark (from the 25%) allocated to each:

| Aspect | Description | Marks (%) |
|--------|-------------|-----------|
| Git | Regular, small, meaningful commits* to your repository throughout development; clear commit messages | 8% |
| README | A comprehensive, well-formatted and accurate README file* (delete the current README file first) | 5% |
| Testing | Tests covering all or almost all of the application; passing tests | 6% |
| External Services* | Integration and utilization of cloud services | 6% |

⚠️ You may not be awarded the 25% software development practices mark if your code has problems or poor quality. Your code must be properly formatted and free from errors, warnings, or suggestions. Make sure your codebase is also well-structured, refactored and relatively free of repetition too. Your code must be your own work (you need to understand it). **Plagiarised code** (e.g., commits showing large chunks of code copied over, especially from other students) will be penalised according to the University’s academic misconduct policy, and you be awarded 0 marks for the entire coursework.

Below are some explanations for the terminology used in the table:

***Regular, small, meaningful commits**: [worksheet 2](https://manighahrmani.github.io/sandwich_shop/worksheet-2.html) onwards on the [Flutter Course homepage](https://manighahrmani.github.io/sandwich_shop/) have demonstrated how to use Git effectively. You need to follow the practice taught in the worksheets.

***README**: Refer to [worksheet 4](https://manighahrmani.github.io/sandwich_shop/worksheet-4.html#writing-a-readme) for guidance on writing a good README file.

***External Services** refer to third-party cloud services like Firebase or Azure that your application integrates with. This could include services like user authentication, database, or hosting the application live on the web. To get marks for this, you must integrate at **least two** separate external services. You are only awarded marks if your README documents this integration and explains how it is used in your application (e.g., provide a live link to the website if you have hosted it).

## Submission

You need to submit the link to your forked repository on Moodle **before the deadline**. Open the Moodle page for Programming Applications and Programming Languages (M30235) or User Experience Design and Implementation (M32605) and find the submission section titled "Item 1 - Set exercise (coursework) (CW)". See below:

![Moodle Submission Page](https://raw.githubusercontent.com/manighahrmani/sandwich_shop/refs/heads/main/images/screenshot_moodle_submission_section.png)

Open the On time or the Late/Extenuating Circumstances submission link and click on Add submission. There you will find an editable Online text field. Paste the link to the GitHub repository for your coursework in the provided text field and click on Save changes. You are **not** submitting any files for this coursework.

![Moodle Submission Online Text](https://raw.githubusercontent.com/manighahrmani/sandwich_shop/refs/heads/main/images/screenshot_moodle_submission_online_text.png)

Make sure the repository is public. Check to see if it opens in an incognito/private window (you should not get a 404 error).

⚠️ You can edit the link itself before the deadline, but do not edit the repository (do not make new commits) after the deadline. I will label your submission as late if you do this.

## Demonstration

The demos take place during your usual timetabled practical sessions in weeks 19 or 20 (Friday 12/12/2025 or Friday 19/12/2025). More information about the demo sessions will be provided closer to the time.

During the demo, you will have **up to 10 minutes** to demonstrate your application to staff. You must clone your repository and run the application live. You need to be prepared to show the features you have implemented and answer any questions about your code.

⚠️ Make sure your application runs correctly (on your personal device or the university computers) from a fresh clone before attending the demo session.

## Project Structure

This starter repository that you will fork provides a minimal skeletal structure with:

- **Homepage** (`lib/main.dart`): A basic homepage
- **Product Page** (`lib/product_page.dart`): A single product page
- **Widget Tests**: Basic tests for both of the above pages (`test/home_test.dart` and `test/product_test.dart`)

Here is an overview of the project structure after forking:

```plaintext
union_shop/
├── lib/
│   ├── main.dart           # Main application and homepage
│   └── product_page.dart   # Product detail page
├── test/
│   ├── home_test.dart      # Homepage widget tests
│   └── product_test.dart   # Product page widget tests
├── pubspec.yaml            # Project dependencies
└── README.md               # This file
```

Note that this is the initial structure. You are expected to create additional files and directories as needed to complete the coursework. You can also reorganize the project structure as you see fit.

# Union Shop — Flutter Coursework

## Project description

This repository contains a Flutter demo application (Union Shop) implemented for coursework. The goal is to recreate core e-commerce features for demonstration and assessment, focusing on functionality and responsive layout rather than exact visual parity.

## Implemented features (brief)

- Static homepage (mobile-first)
- Responsive navigation (mobile/desktop)
- About page (static)
- Footer with dummy links
- Collections list and single collection page (data-driven)
- Product detail pages (images, variants, add to cart)
- Sale collection page
- Authentication UI (example sign-in/sign-up forms)
- Shopping cart (add, quantity edit, persistence via SharedPreferences)
- Search results page
- Print Shack personalise demo page

## Run & Test

Install dependencies and run the app:

```powershell
flutter pub get
flutter run    # or specify device: flutter run -d chrome / -d windows
```

Run tests:

```powershell
flutter test
```

## Continuous Integration (CI)

The repository includes a GitHub Actions workflow `.github/workflows/ci.yml` that runs on push/PR and performs `flutter pub get`, `flutter analyze`, and `flutter test` for automated checks.

## External services & integration (brief)

Current implementation is offline/demo-only and does not depend on cloud services. For full production-like features we recommend integrating:

- Firebase Auth (user authentication)
- Firebase Firestore (orders / user data persistence)

If you want, I can generate example integration code and document how to add the required config files (do not commit credentials to a public repo).

## Marking mapping (brief)

- Application (30%): Most basic and intermediate features are implemented (estimated ~27/30).
- Software development practices (25%): Needs more tests, clearer commit history and evidence of external service integration (estimated ~7/25).

---

## 项目描述（中文）

本仓库为课程作业实现的 Flutter 演示应用（Union Shop），目标是复现在线商店的大部分功能用于演示与评估，侧重功能性与响应式布局。

## 已实现功能（简要，中文）

- 静态主页（移动优先）
- 响应式导航栏（移动/桌面）
- 关于页面（静态）
- 页脚（虚拟链接）
- Collections 列表与单一 Collection 页面（数据驱动）
- 产品详情页（图片、变体、加入购物车）
- 促销/特价页面
- 认证界面（示例登录/注册表单）
- 购物车（加入、数量编辑、通过 SharedPreferences 持久化）
- 搜索结果页面
- Print Shack 个性化示例页面

## 运行与测试（中文）

安装依赖并运行应用：

```powershell
flutter pub get
flutter run    # 或指定设备： flutter run -d chrome / -d windows
```

运行测试：

```powershell
flutter test
```

## 持续集成（CI）（中文）

仓库包含 GitHub Actions 工作流 `.github/workflows/ci.yml`，在 push/PR 时运行 `flutter pub get`、`flutter analyze` 与 `flutter test`，用于自动化检查与测试。


## 评分映射（简要，中文）

- 应用功能（30%）：已实现大部分基础与中级功能（估算约 27/30）。
- 软件开发实践（25%）：仍需补充更多测试、清晰提交历史与外部服务证据（估算约 7/25）。

