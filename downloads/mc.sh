cd mc
echo "Майнкрафт сервер загружается, ждите" > ../ip.txt

# start tunnel
mkdir -p ./logs
touch ./logs/temp # avoid "no such file or directory"
rm ./logs/*
echo "Запускается ngrok на континенте $ngrok_region"
./ngrok authtoken $ngrok_token
touch logs/ngrok.log
./ngrok tcp -region $ngrok_region --log=stdout 1025 > ./logs/ngrok.log &
# wait for started tunnel message, and print each line of file as it is written
tail -f ./logs/ngrok.log | sed '/started tunnel/ q'
orig_server_ip=`curl --silent http://127.0.0.1:4040/api/tunnels | jq '.tunnels[0].public_url'`
trimmed_server_ip=`echo $orig_server_ip | grep -o '[a-zA-Z0-9.]*\.ngrok.io[0-9:]*'`
server_ip="${trimmed_server_ip:-$orig_server_ip}"
echo "IP сервера: $server_ip"
echo "Сервер запущен на: $server_ip" > ../ip.txt

touch logs/latest.log
# Experiment: Run http server after all ports are opened
#( tail -f ./logs/latest.log | sed '/RCON running on/ q' && python3 -m http.server 8080 ) &

# Start minecraft
#PATH=$PWD/jre/bin:$PATH
echo "Сервер запущен..."
../java/bin/java -Xmx1G -Xms1G -jar server.jar nogui
echo "Код выхода $?"
