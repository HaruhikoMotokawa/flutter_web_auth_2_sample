# flutter_web_auth_2_sample

このプロジェクトはFlutterでQiitaAPIとOAuth2.0を使った認証と認可を行うサンプルプログラムです。

## 概要
アプリでサーバー側の認証と認可を行うパッケージであるflutter_web_auth_2を使ったサンプルを
目的に当初は作成していました。
しかし、認証と認可を行うためには多くのパッケージを必要としました。
よってタイトルのパッケージ以外にも多彩なパッケージを使っています。

主なパッケージ
- flutter_web_auth_2
- envied:
- dio:
- shared_preferences:
- flutter_riverpod:
- flutter_hooks:
- hooks_riverpod:
- flutter_secure_storage:
- freezed_annotation:
- json_annotation:

## enviedによる難読化
クライアントIDとクライアントシークレットはenviedを使って難読化しています。
また、GitHub上では元のenvファイルはプッシュしていません。
手元でビルドする場合はQiitaAPIを使うための設定を行い、クライアントIDとクライアントシークレットを
取得する必要があります。

## 画面とファイル構成
アプリを起動すると最初の画面には二つのボタンが設置されています。
一つは`PlainLoginPage`に遷移し、もう一つは`LogInPage`に遷移します。
どちらもできることは一緒で、設計を変えています。

1.ログイン画面からログインボタンを押すとアプリ内ブラウザを展開します。
2.ブラウザではQiitaの認証画面を開き、ユーザーはログイン処理を行います。
3.認証されると認可コードの発行が行われます。
4.認可コードを使ってアクセストークンを取得し、ローカルに保存します。
5.アクセストークンを使ってQiitaに登録されているユーザー情報を取得します。
6.認証が成功するとホーム画面に遷移し、取得したユーザー情報を表示します。
7.ホーム画面にはログアウトボタンがあり、アクセストークンの削除と前の画面に戻る処理を実行します。

### `plain`
ざっくり表現するとMVCのような形で書いています。
ひとまず認証、認可の流れを説明すべく実際の運用ではもっと細かく設計する部分を省いて
書いています。

### `refactor`
いずれレイヤードアーキテクチャをベースに`plain`で書いた処理を書き直そうと思っています。
現在はまだ作業中で未完成です。