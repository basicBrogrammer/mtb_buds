const initialResponseHandler = (response) => {
  if (response.status >= 200 && response.status < 300) {
    return response.text()
  } else {
    var error = new Error(response.statusText)
    error.response = response
    throw error
  }
};

const catchHandler = (error, target) => {
  const errorMessage = `
          <div class='row'>
            <div class='main-page-grid center-align'>
              <h4>Sorry, something went wrong.</h4>
              <p>We have received a notification and we will try to get to the bottom of this.</p>
              <p>Please try again later.</p>
            </div>
          </div>
        `
  $(target).append(errorMessage);
};

export { initialResponseHandler, catchHandler };
