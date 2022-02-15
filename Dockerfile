# 여기 FROM 부터 다음 FROM 전까지는 모두 builder stage 라는 것을 명시
# 생성된 파일, 폴더들은 /usr/src/app/build 로 들어간다.
FROM node:alpine as builder
WORKDIR '/usr/src/app'
COPY package.json .
RUN npm install
COPY ./ ./
CMD ["npm", "run", "build"]

# Nginx를 위한 베이스 이미지
FROM nginx

# 다른 stage에 있는 파일을 복사할 때 다른 stage 이름을 명시
# builder stage에서 생성된 파일들은 /usr/src/app/build에 들어가게 되고 
# 저장된 파일들을 /usr/share/nginx/html로 복사해서
# nginx가 웹 브라우저의 요청이 올 때마다 알맞은 파일을 전해줄 수 있게 만든다.
COPY --from=builder /usr/src/app/build /usr/share/nginx/html