ARG APP=inspect

FROM reg.smvm.cn/appbase/golang-build:1.21-alpine3.17 AS builder


ARG APP
ENV GO111MODULE=on
ENV GOPROXY=https://goproxy.cn,direct

ENV TZ Asia/Shanghai
WORKDIR ${APP}

COPY . .
RUN make build \
    && mkdir /data/ \
    && mv ./bin/*  /data/ \
    && mv ./config  /data/



# 运行阶段
FROM reg.smvm.cn/appbase/alpine:3.10.1 as final

ARG APP
ENV APP=${APP}
ENV WORKDIR=/data
WORKDIR ${WORKDIR}
COPY --from=builder ${WORKDIR}/ ./

RUN apk add curl
ENV TZ Asia/Shanghai

EXPOSE 9001
EXPOSE 9002
EXPOSE 9003
EXPOSE 50051
CMD ["sh", "-c", "./${APP} server"]
