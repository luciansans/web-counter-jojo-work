FROM python:3.13.0

# cd in folder
WORKDIR /usr/src/app

COPY requirements.txt .

#pip install
RUN pip install -r requirements.txt

#copy the py file 
COPY app.py .

#expose 
EXPOSE 5000

# run
CMD ["python", "app.py"]