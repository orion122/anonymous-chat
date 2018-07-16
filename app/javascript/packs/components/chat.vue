<template>
    <div id="chat" class="chat">
        <button @click='logout' class='logout'>{{ this.$t('chat.leave_chat') }}</button>
        <ul class="messages" v-chat-scroll>
            <li class="message" v-for="n in messages">{{ n }}</li>
        </ul>
        <input type="text" class='input-box_text' v-model.trim="message" @keyup.enter="saveMessage()" />
    </div>
</template>

<script>
    export default {
        data() {
            return {
                message: '',
                messages: [],
                current_session_token: localStorage.getItem('session_token'),
                last_received_id: 0
            }
        },
        mounted: function(){
            setInterval(() => {
                if (window.location.pathname == `/chats/${this.getChatToken()}`) {
                    this.getMessages()
                    // Rollbar.info("JS: Get all messages after 5 sec")
                }
            }, 5000);
        },
        methods: {
            logout() {
                localStorage.removeItem('session_token')
                this.$router.push('/')
            },
            getMessages() {
                this.$http.get(`/chats/${this.getChatToken()}/messages`,
                    {params: {last_received_id: this.last_received_id}}
                ).then(response => {
                    let nicknameAndMessage = ''
                    let nicknamesAndMessages = response.body.reduce(((init, messageObject) => {
                        nicknameAndMessage = `${messageObject.nickname}: ${messageObject.message}`
                        if ((messageObject.session_token === this.current_session_token) &&
                            (messageObject.state !== 'delivered')) {
                            nicknameAndMessage += ` (${messageObject.state})`
                        }
                        init.push(nicknameAndMessage)
                        return init
                    }), [])
                    this.messages = [...this.messages, ...nicknamesAndMessages]
                    console.log(response.body[response.body.length - 1].id)
                    this.last_received_id = response.body[response.body.length - 1].id
                });
                // Rollbar.info("JS: Get all messages")
            },
            saveMessage() {
                if(this.message !== '') {
                    this.$http.post(`/chats/${this.getChatToken()}/messages`,
                        {message: this.message}
                    ).then(response => {
                        this.message = ''
                        this.getMessages()
                    });
                    // Rollbar.info("JS: Save message")
                }
            },
            setStateRead() {
                this.$http.post(`/chats/${this.getChatToken()}/messages/set_state_read`,
                    {message: this.message}
                );
            },
            getChatToken() {
                return window.location.href.split('/').reverse()[0]
            }
        },
        watch: {
            messages: function () {
                this.setStateRead()
            }
        }
    }
</script>