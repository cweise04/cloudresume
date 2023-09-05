// Wait for the DOM to be fully loaded before executing the code
window.addEventListener('DOMContentLoaded', (event) => {
    getVisitorCount();
});

// Replace 'const functionapi = ''; with the actual API endpoint URL
const functionapi = 'https://';

const getVisitorCount = () => {
    let count = 30;

    // Use the fetch API to make a GET request to your API endpoint
    fetch(functionapi).then(response => {
            // Check if the response status is OK (status code 200)
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            // Update the count with the data from the API response
            count = data.response; // Assuming the API response has a 'response' field
            document.getElementById("counter").innerText = count;
        })
        .catch(error => {
            console.error(error);
        });
}
