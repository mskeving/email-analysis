React = require('react')
V     = React.PropTypes

module.exports = React.createClass
  displayName: 'FAQDisplay'

  propTypes:
    data: V.array

  componentDidMount: ->
    # Note: Don't require jquery in this. Materialize is dependent on the global
    # jquery defined in the base template.
    $('.collapsible').collapsible({accordion: true})

  _get_qa: (question_to_anwer, i) ->
    question = question_to_anwer.question
    answer = question_to_anwer.answer
    return (
        <li key={i}>
          <div className="collapsible-header faq-question">{question}</div>
          <div className="collapsible-body"><p>{answer}</p></div>
        </li>
    )
  render: ->
    <div className="page-container">
      <h3>FAQ</h3>
      <ul className="collapsible" data-collapsible="accordion">
        {@props.data.map((question_to_anwer, i) => return @_get_qa(question_to_anwer, i))}
      </ul>
    </div>
