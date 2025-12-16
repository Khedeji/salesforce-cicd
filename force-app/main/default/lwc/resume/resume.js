import { LightningElement, track } from 'lwc';

export default class AssistantChat extends LightningElement {
    @track isOpen = false;
    @track userInput = '';
    @track messages = [];

    toggleChat() {
        this.isOpen = !this.isOpen;
        if (this.isOpen) {
            setTimeout(() => this.scrollToBottom(), 0);
        }
    }

    handleInput(event) {
        this.userInput = event.target.value;
    }

    handleKeyDown(event) {
        if (event.key === 'Enter') {
            this.sendMessage();
        }
    }

    sendMessage() {
        const input = this.userInput.trim();
        if (!input) return;
        this.addMessage('user', input);
        this.userInput = '';
        this.fetchAIResponse(input);
    }

    addMessage(sender, text) {
        this.messages.push({ sender, text });
        this.renderMessages();
    }

    renderMessages() {
        const messagesDiv = this.template.querySelector('#messages');
        if (messagesDiv) {
            messagesDiv.innerHTML = this.messages.map(msg =>
                `<div class="msg ${msg.sender}"><span>${msg.text}</span></div>`
            ).join('');
            this.scrollToBottom();
        }
    }

    scrollToBottom() {
        const messagesDiv = this.template.querySelector('#messages');
        if (messagesDiv) {
            messagesDiv.scrollTop = messagesDiv.scrollHeight;
        }
    }

    async fetchAIResponse(question) {
        this.addMessage('ai', '...');
        try {
            // Replace 'https://xyz.com/api' with your actual endpoint
            const response = await fetch('https://xyz.com/api', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ question })
            });
            const data = await response.json();
            this.messages.pop(); // remove '...'
            this.addMessage('ai', data.answer || 'Sorry, I could not understand.');
        } catch (e) {
            this.messages.pop();
            this.addMessage('ai', 'Error contacting AI service.');
        }
    }

    renderedCallback() {
        this.renderMessages();
    }
}