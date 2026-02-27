# feature： task_service
ユーザーがHiveに登録したタスクを取得や追加、削除などをまとめた共通ロジック

## getTasks
すべてのタスクをHiveから取得するメソッド。  

- **引数**: なし
- **戻り値**: `List`

### 処理  
- Hiveの`tasks`ボックスからすべてのタスクを取得する  
  - リスト型に変換してreturnする

## addTask
ユーザーが登録したタスクをHiveに保存するメソッド。

- **引数**: `<String> task, <int>duration`
- **戻り値**: `void`

### 処理
- `Task`型のtaskDataをHiveの`tasks`ボックスに格納する

### データ構造
`id`はUuidを使って生成する。
```dart
class Task {
  'id': String,
  'task': String,
  'duration': int,
  'isCompleted': bool
}
```

## completeTask
ユーザーがタスクをスワイプして完了させた時、当該のタスクを完了に変更するメソッド

- **引数**: id
- **戻り値**: `void`

### 処理
- 引数の`id`を元にHiveの`tasks`ボックスから当該のタスクを取り出す  
  - 指定したタスクが存在しなければ早期returnする。
- 当該タスクのisCompletedを`true`に変更し保存する
