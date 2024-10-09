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


