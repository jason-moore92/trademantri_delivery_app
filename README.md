# delivery_app

# 2021-11-18 start

A new Flutter project.

#### Commands

1. Prod build cmd `flutter build appbundle --target lib/main_prod.dart --release --flavor prod`
2. Qa build cmd `flutter build appbundle --target lib/main_qa.dart --release --flavor qa`
3. Extract apk from aab
   1. `java -jar .\bundletool.jar build-apks --bundle=./Delivery_1.0.0+1_qa.aab --output=Delivery_1.0.0+1_qa.apks --mode=universal` mode universal gives the single apk file.
4. Start CI/CD pipelines `aws codepipeline start-pipeline-execution --name tmdlvyapp-qa`
5. Generate freezed entities: `flutter pub run build_runner build`.