# README

.git/config
[merge "ours"]
    name = "Keep ours merge"
    driver = true

.gitattributes
/.gitignore merge=ours


Steps to generate gradle project
- gradle init
    - libフォルダに環境が構築される
- プロジェクトフォルダの直下に開発環境を生成する場合
    - move files under lib 
    - delete include('lib') in settings.gradle
- ./gradlew eclipse ?
- start eclipse
- settings Peoject properties
    - Project facets
    - Targeted runtime
    - Add id 'war' 
- update build.gradle ... example
    - Add "id 'war'" in plugins directive
    - Comment out "implementation 'com.google.guava:guava:30.1.1-jre'"
    - Add compileOnly fileTree(...) in dependencies directive
