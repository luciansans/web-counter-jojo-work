FROM python:3.13.0

# cd in folder
WORKDIR /usr/src/app

COPY web-counter/requirements.txt .

#pip install
RUN pip install -r requirements.txt

#copy the py file 
COPY web-counter/app.py .

#expose 
EXPOSE 5000

# run
CMD ["python", "app.py"]