ARG GLUE_VERSION
FROM amazon/aws-glue-libs:$GLUE_VERSION
ADD ./requirements.txt /app/requirements.txt
RUN pip3 install -r /app/requirements.txt
WORKDIR /app/
