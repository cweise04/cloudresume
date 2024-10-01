const countDiv = document.querySelector(".counter");

async function updateCount() {
    try {
        let response = await fetch("https://5u5z1zn3k3.execute-api.us-east-1.amazonaws.com/chrisweisecloudresume/", {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json' 
            }
        });
        
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }

        let data = await response.json();
        countDiv.innerHTML = `This page has been visited ${data.new_count} times.`; 

    } catch (error) {
        console.error('Error fetching the data:', error);
        countDiv.innerHTML = "Couldn't read view";
    }
}

updateCount();
