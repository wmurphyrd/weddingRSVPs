# weddingRSVPs
##Making google forms RSVP responses into useful data
Munges messy data from google forms wherein are varying number of responses to each question are 
concatenated in single cells. Uses the tidyr paradigm but with a custom cell splitting function because
tidyr::extract can only split values if the number of extractable responses is equal in every cell. Rearranges the data
to provide a total number of guests at each location/time combo and a list of email addresses of attenddess formatted 
for simple copy/paste into calendar invitations.
