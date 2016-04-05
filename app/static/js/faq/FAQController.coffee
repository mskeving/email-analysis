require("../../stylesheets/faq.scss")
React      = require('react')
FAQDisplay = require('./FAQDisplay')

module.exports = React.createClass
  displayName: 'FAQController'

  questions: [
    {
      question: "What emails are included in this analysis?"
      answer: "Any email that is FROM one of the five of
      us and is TO the other four, using any of our email
      address. If there are other recipients on the TO field
      outside of our family, that email is included. If someone
      from our family was cc-ed, that email is not included."
    }
    {
      question: "Does this include chats?"
      answer: "No. No Google Hangouts or WhatAapp data are
      included here."
    }
    {
      question: "Should I be worried about my privacy?"
      answer: "Well, yes, probably, but not because of
      me. There is no way I can gain access to your
      email accounts. Everything here comes from my own account."
    }
    {
      question: "Where is everything stored?"
      answer: "Skarkov is hosted by a company called Heroku.
      They provisioned a Postgres database for me to store
      this data. Many many companies use  Heroku to host
      their site and store their data. I trust that it
      is safe."
    }
    {
      question: "How long have you been working on this?"
      answer: "On and off since June, 2015."
    }
    {
      question: "I think this website it pretty and all,
      but I’d really prefer to read through all the lines
      of code you wrote with your own two hands. Where can
      I find that?"
      answer: <a target="_blank" href="https://github.com/mskeving/email-analysis">
        https://github.com/mskeving/email-analysis
        </a>
    }
    {
      question: "If all the code is online and public,
      should I be worried about spammers or weird people
      finding my email address?"
      answer: "No. This project was built with open-source
      in mind and nothing was hardcoded. There is no way
      to tie this project to you in any way from the code directly."
    }
    {
      question: "What was the hardest part of this project?"
      answer: "EVERYTHING WAS HARD."
    }
    {
      question: "I have feature requests! How can I get them implemented?"
      answer: "Email me. My product manager will prioritize and
      determine if it’s worthy of my development time."
    }
    {
      question: "I don’t trust that this is an accurate portrayal
      of our email habits. Who can I talk to?"
      answer: "Noone."
    }
  ]

  render: -> return (
    <FAQDisplay data=@questions />
  )
