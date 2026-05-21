# colecao_livros

## 1. Habilitar o suporte Web no Flutter
Antes de tudo, certifique-se de que o Flutter está autorizado a rodar projetos web na sua máquina. Abra o terminal (Prompt de Comando ou PowerShell) na pasta do seu projeto e execute:

Bash
flutter config --enable-web
## 2. Baixar as Dependências
Garanta que todas as bibliotecas do arquivo pubspec.yaml estejam instaladas corretamente para o ambiente web rodando:

Bash
flutter pub get
## 3. Descobrir os Dispositivos Disponíveis
Para ter certeza de que o seu navegador foi reconhecido pelo Flutter como um alvo de compilação, digite:

Bash
flutter devices
Na lista que aparecer, você verá algo como Chrome (web) ou Edge (web).

## 4. Rodar o Web Server
Você tem duas formas de executar o projeto no navegador, escolha a que preferir:

Opção A: Abrir direto no navegador padrão (Mais comum)
Esse comando compila o projeto e abre automaticamente uma janela do Chrome ou Edge rodando o app:

Bash
flutter run -d chrome
(Se preferir o Edge, mude para flutter run -d edge)

Opção B: Iniciar apenas o Servidor (Ideal para redes ou se quiser o link)
Se você quiser que o Flutter apenas crie um servidor local e te dê o link (URL) para você colar em qualquer navegador manualmente, use:

Bash
flutter run -d web-server
O terminal vai processar o código e gerar um endereço parecido com este:
http://localhost:8080 (basta copiar, colar no navegador e dar Enter).