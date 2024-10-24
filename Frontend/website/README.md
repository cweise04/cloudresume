# aws-resume-challenge
My Resume Challenge Distrubtion

## Frontend
## First Step
- Used html/css template for website [resume template](https://github.com/startbootstrap/startbootstrap-resume)
- Frontend folder contains:
    - html
    - css
    - website images
    - 404 error html
    - counter.js contains visitor counter code.

## Second Step
- Created a S3 resource and enabled static website hosting.
    - Enabled permissions for S3 static website hosting.
- Created a CloudFront resource for CDN for the website. 
- Created a DNS name through aws (https://www.chrisweise.com/)
    - This required me to create a SSL certificate for my DNS name.

## Building the API, and Frontend/Backend integration
## First Step

- Created a DynamoDB table.
- Created an IAM role for Lambda that allows Lambda and DynamoDB to work together.
- Created a Lambda function with Python code 
    - I set up Lambda to be able to interact with my Api Gateway and DynamoDb allowing me to track visitor counts on my website.
- Created a rest API on API Gateway with Lambda proxy enabled.
    - I created a POST method to be able to post my count in DyanmoDB
    - Once all 3 were created and linked I tested it from an outside website called Postman.
- Finally I set up CloudWatch alarms to monitor Lambda. 
    - I monitored Lambda's concurrent executions, API Gateway latency, and API request counts over a given period of time.
    - I also set up budget alarms to notify me if my aws project was within 75% of my budgeted amount, at my budgeted amount, and over my budgeted amount.

## Second Step
- CORS configuration
    - This required me to enable CORS in my API Gateway.
    - I also had to add CORS configurations in Lambda and S3 because Lambda enforces the Same Origin Policy. 
- Created JavaScript for counter that I linked my html to.
    -JS Code

const countDiv = document.querySelector(".counter");

async function updateCount() {
    try {
        let response = await fetch("https://e5fazlk3rg.execute-api.us-east-1.amazonaws.com/prod/count", {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json' 
            }
        });

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        let responseBody = await response.text(); 
        let data = JSON.parse(responseBody); 

        countDiv.innerHTML = `This page has been visited ${data.new_count} times!`; 

    } catch (error) {
        console.error('Error fetching the count:', error);
        countDiv.innerHTML = "Error loading visit count.";
    }
}

updateCount();

- Invalidated my CloudFront cache.
    - I did this so that I could make sure my website was collecting the visit count.
- Finally I created a end-to-end test(Smoke Test).
    - It was a Python test in VS Code using Playwright.
        - Smoke Test 
            - Page Load Test: Ensures the page loads successfully
            - Basic Navigation Test: Ensures links and buttons are clickable and navigate to the correct place.
            - Counter Test: Updates and retrieves the correct count.
            - 


## 














