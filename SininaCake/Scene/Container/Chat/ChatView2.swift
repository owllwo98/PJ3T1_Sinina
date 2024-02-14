//
//  ChatView2.swift
//  SininaCake
//
//  Created by 김수비 on 2/14/24.
//

import SwiftUI

struct ChatView2: View {
    
    @ObservedObject var chatVM = ChatViewModel.shared
    //@ObservedObject var fbManager = FirebaseManager.shared
    //@ObservedObject var userStore = UserStore.shared
    
    @State var chatText = ""
    @State var loginUserEmail: String? // 로그인 유저
    @State var room: ChatRoom // 로그인한 유저의 채팅방
//    @State var userEmail: String?
    
    
    // MARK: 통합 뷰
    var body: some View {
        VStack {
            messagesView
//                .navigationTitle(chatVM.currentRoom?.userName ?? "")
//                .navigationBarTitleDisplayMode(.inline)
                .padding(.top, 10)
            
            chatBottomBar
        }
    }
    
    // MARK: 메세지 창 띄우는 뷰
    private var messagesView: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        if chatVM.messages[room.id] != nil {
                            ForEach(chatVM.messages[room.id]!!, id: \.self) { msg in
                                // 나
                                if loginUserEmail == msg.userEmail {
                                    blueMessageBubble(message: msg)
                                    
                                    // 상대
                                } else {
                                    grayMessageBubble(message: msg)
                                }
                                
                            }
                            .background(Color.clear)
                            .onChange(of: chatVM.lastMessageId){ id in
                                withAnimation {
                                    // 마지막 말풍선을 따라 스크롤로 내려감
                                    proxy.scrollTo(id, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            chatVM.fetchRoom(userEmail: room.userEmail)
        }
    }
    
    //MARK: 채팅 치는 뷰
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "plus")
                .font(.system(size: 24))
                .foregroundColor(Color.init(UIColor.customGray))
            
            ZStack {
                // 텍스트 입력
                TextField("Enter your message", text: $chatText)
                    .background(Color.init(UIColor.customGray))
                    .cornerRadius(8)
            }
            .frame(height: 40)
            
            Button {
                let msg = Message(text: chatText, userEmail: loginUserEmail ?? "" , timestamp: Date())
                chatVM.sendMessage(chatRoom: room, message: msg)
            } label: {
                Image(systemName: "paperplane")
                    .foregroundColor(Color.init(UIColor.customGray))
                    .frame(width: 24, height: 24)
            }
        }
        .padding()
    }
    
    // MARK: - 파란 말풍선
    private func blueMessageBubble(message: Message) -> some View {
        HStack {
            CustomText(title: message.timestamp
                .formattedDate(), textColor: .customGray, textWeight: .regular, textSize: 12)
            
            CustomText(title: message.text, textColor: .white, textWeight: .regular, textSize: 16)
                .padding()
            
            
                .background(Color.init(UIColor.customBlue))
                .cornerRadius(30)
            
        } // VStack
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.horizontal, 10)
    }
    
    // MARK: - 회색 말풍선
    private func grayMessageBubble(message: Message) -> some View {
        HStack {
            CustomText(title: message.text, textColor: .white, textWeight: .regular, textSize: 16)
                .padding()
                .background(Color.init(UIColor.customGray))
                .cornerRadius(30)
            
            CustomText(title: message.timestamp
                .formattedDate(), textColor: .customGray, textWeight: .regular, textSize: 12)
            
        } // VStack
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
    }
}

#Preview {
    ChatView2(loginUserEmail: "a@gmail.com", room: ChatRoom(userEmail: "a@gmail.com", userName: "이찰떡", date: Date(), id: "iDe7zgI8rZTbXKTSb7id"))
}
