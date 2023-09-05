# azure-resume-challenge
My Resume Challenge Distrubtion 
[following ACG project video](https://www.youtube.com/watch?v=ieYrBWmkfno&list=LL&index=3&t=2102s)


## First Steps 
- used Httml/css template for website [resume template](https://github.com/startbootstrap/startbootstrap-resume)
- frontend folder contains website
- counter.js contains visitor counter code.

## Second Steps
- Created a Static Storage website Resource in Azure
- Created an Endpoint and a CDN for the website
- Created a DNS name through Name Cheap [DNS Cloud Resume Website Link](https://www.cwcloudresume.me/)
- Created a Cosmosdb database


## Third Steps
- Backend folder contains page counter code in JavaScript

## Js Code
window.addEventListener('DOMContentLoaded', (event) => {
    getVisitorCount();
});

const functionapi = 'https://';

const getVisitorCount = () => {
    let count = 30;
    fetch(functionapi).then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            count = data.response;
            document.getElementById("counter").innerText = count;
        })
        .catch(error => {
            console.error(error);
        });
}


