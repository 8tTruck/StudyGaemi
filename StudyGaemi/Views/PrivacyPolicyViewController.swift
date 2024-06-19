//
//  PrivacyPolicyViewController.swift
//  StudyGaemi
//
//  Created by 강태영 on 6/9/24.
//

import SnapKit
import Then
import UIKit

class PrivacyPolicyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        setupBackButton()
        configureScrollView()
    }
    
    private func setupBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 17)
        backButton.tintColor = UIColor(named: "fontBlack") // 이미지 색상을 설정
        backButton.setTitleColor(UIColor(named: "fontBlack"), for: .normal) // 텍스트 색상을 설정
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }

    private func configureScrollView() {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(named: "viewBackgroundColor")
        let contentView = UIView()
        contentView.backgroundColor = UIColor(named: "viewBackgroundColor")
        let textView = UILabel().then {
            $0.text = """
                개인정보 보호 담당부서

                개인정보 보호 담당자 : 강태영

                공부하개미 개인정보처리방침

                본 개인정보 처리방침은 2024년 6월 일부터 적용됩니다.

                팀 핸들이 멀쩡한 8톤트럭(이하 “운영팀”)은 정보주체의 자유와 권리 보호를 위해 「개인정보 보호법」 및 관계 법령이 정한 바를 준수하여, 적법하게 개인정보를 처리하고 안전하게 관리하고 있습니다. 이에 「개인정보 보호법」 제30조에 따라 정보주체에게 개인정보의 처리와 보호에 관한 절차 및 기준을 안내하고, 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리방침을 수립・공개합니다.

                **제1조 (개인정보의 처리 목적 및 항목)**

                운영팀은 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음 목적 이외의 용도로는 이용되지 않으며, 이용 목적이 변경되는 경우에는 「개인정보 보호법」 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.

                1. 회원 가입 및 관리
                    - 회원 가입 의사 확인, 회원제 서비스 제공에 따른 본인 식별·인증, 회원자격 유지·관리, 서비스 부정이용 방지, 각종 고지·통지, 고충처리 목적으로 개인정보를 처리합니다.
                2. 운영팀은 다음의 개인정보 항목을 정보주체의 동의를 받아 처리하고 있습니다.
                    1. 회원 서비스 운영 (필수)
                        - 법적 근거: 개인정보 보호법 제15조 제1항 제4조
                        - 수집·이용 항목: 이메일주소, 비밀번호, 닉네임
                        - 보유 및 이용 기간: 회원 탈퇴시까지
                    2. 서비스/업데이트 정보 제공, 맞춤형 서비스 제공, 이벤트 안내 (선택)
                        - 수집·이용 항목: 이메일주소, 서비스 이용기록
                        - 보유 및 이용 기간: 동의 철회 또는 회원 탈퇴시까지
                3. 서비스 이용 과정에서 단말기정보, IP주소, 쿠키, 서비스 이용 내역* 아래와 같은 정보들이 자동으로 생성되어 수집될 수 있습니다.
                    
                    * 서비스 이용 내역이란 서비스 이용 과정에서 자동화된 방법으로 생성되거나 이용자가 입력한 정보가 송수신되면서 서버에 자동으로 기록 및 수집될 수 있는 정보를 의미합니다. 이와 같은 정보는 다른 정보와의 결합 여부, 처리하는 방식 등에 따라 개인정보에 해당할 수 있고 개인정보에 해당하지 않을 수도 있습니다.
                    
                4. 유료 서비스
                재화의 구매 및 결제, 콘텐츠 제공, 요금결제·정산
                결제 기록
                서비스 해지시까지(단, 관련법령에 따라 보관되는 정보는 예외)

                ※ 카카오, 네이버, 페이스북, 구글, Apple계정으로 가입하는 SNS회원가입의 경우, 운영팀은 해당 서비스 제공자가 보내는 비식별화되고 추적이 불가능한 고유 Key값을 통해서만 계정을 생성하며, 개인정보에 해당하는 정보는 수집하지 않습니다.

                운영팀은 회원이 탈퇴하거나, 처리·보유목적이 달성되거나 보유기간이 종료한 경우 해당 개인정보를 지체 없이 파기합니다. 단 아래와 같이 관계법령에 의거하여 보존할 필요가 있는 경우에는 일정 기간 동안 개인정보를 보관할 수 있습니다.

                **제2조(처리하는 개인정보의 보관기간 및 이용기간)**

                1. 운영팀은 법령에 따른 개인정보 보유・이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의 받은 개인정보 보유・이용기간 내에서 개인정보를 처리・보유합니다.
                2. 개인정보의 내용은 다음과 같습니다.
                    1. 이메일
                    2. 비밀번호
                    3. 닉네임
                3. 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.
                    1. 회원 가입 및 관리: 회원 탈퇴 시까지
                4. 다만, 다음의 사유에 해당하는 경우에는 해당 사유 종료 시까지
                    1. 관계 법령 위반에 따른 수사·조사 등이 진행 중인 경우에는 해당 수사·조사 종료 시까지
                    2. 관계법령에 따라 보관 의무가 주어진 경우 (단, 아래에 한정되지 않음)
                        - 계약 또는 청약철회 등에 관한 기록: 5년 (전자상거래 등에서의 소비자보호에 관한 법률)
                        - 대금결제 및 재화의 공급에 관한 기록: 5년 (전자상거래 등에서의 소비자보호에 관한 법률)
                        - 소비자의 불만 또는 분쟁처리에 관한 기록: 3년 (전자상거래 등에서의 소비자보호에 관한 법률)
                        - 웹사이트 방문기록: 3개월 (통신비밀보호법)
                    3. 내부 방침에 의해 보관하는 경우 (아래에 한정됨)
                        - 서비스 부정이용 기록: 탈퇴일로부터 최대 1년
                5. 운영팀은 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.
                6. 정보주체로부터 동의받은 개인정보 보유기간이 경과하거나 처리목적이 달성되었음에도 불구하고 다른 법령에 따라 개인정보를 계속 보존하여야 하는 경우에는, 해당 개인정보를 별도의 데이터베이스(DB)로 옮기거나 보관장소를 달리하여 보존합니다.

                **제3조 (개인정보의 안전성 확보조치)**

                1. 운영팀은 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다.
                    1. 관리적 조치 : 내부관리계획 수립・시행, 전담조직 운영, 정기적 직원 교육
                    2. 기술적 조치 : 개인정보처리시스템 등의 접근권한 관리, 접근통제시스템 설치, 개인정보의 암호화
                    3. 물리적 조치 : 전산실, 자료보관실 등의 접근통제

                **제 4조 (정보주체의 권리와 그 행사방법)**

                1. 회원은 언제든지 개인정보 열람・정정・삭제・처리정지 및 철회 요구, 자동화된 결정에 대한 거부 또는 설명 요구 등의 권리를 행사(이하 “권리 행사”라 함)할 수 있습니다.
                2. 권리 행사는 「개인정보 보호법」 시행령 제41조 제1항에 따라 전자우편 등을 통해 요청할 수 있으며, 운영팀은 이에 대해 지체없이 조치하겠습니다.
                    - 회원은 언제든지 ‘마이페이지’에서 개인정보를 직접 조회・수정・삭제하거나 ‘문의하기’를 통해 열람을 요청할 수 있습니다.
                    - 회원은 언제든지 ‘회원탈퇴’를 통해 개인정보의 수집 및 이용 동의 철회가 가능합니다.
                3. 권리 행사는 정보주체의 법정대리인이나 위임을 받는 자 등 대리인을 통하여 하실 수 있습니다. 이 경우 “ 개인정보 처리 방법에 관한 고시” 별지 제 11호 서식에 따른 위임장을 제출하셔야합니다.
                4. 정보주체가 개인정보 열람 및 처리 정지를 요구할 권리는 「개인정보 보호법」 제35조 제4항 및 제37조 제2항에 의하여 제한될 수 있습니다.
                5. 다른 법령에서 그 개인정보가 수집 대상으로 명시되어 있는 경우에는 해당 개인정보의 삭제를 요구할 수 없습니다.
                6. 자동화된 결정이 이루어진다는 사실에 대해 정보주체의 동의를 받았거나, 계약 등을 통해 미리 알린 경우, 법률에 명확히 규정이 있는 경우에는 자동화된 결정에 대한 거부는 인정되지 않으며 설명 및 검토 요구만 가능합니다.
                    - 또한 자동화된 결정에 대한 거부・설명 요구는 다른 사람의 생명・신체・재산과 그 밖의 이익을 부당하게 침해할 우려가 있는 등 정당한 사유가 있는 경우에는 그 요구가 거절될 수 있습니다.
                7. 운영팀은 권리 행사를 한 자가 본인이거나 정당한 대리인인지를 확인합니다.
                8. 운영팀은 권리 행사를 아래의 부서에 할 수 있습니다. 운영팀은 정보주체의 권리 행사가 신속하게 처리되도록 노력하겠습니다.
                    - 개인정보 열람 등 청구 접수・처리 부서
                        - 부서명: 개인정보보호팀
                        - 이메일: [taengdev@gmail.com](mailto:taengdev@gmail.com)

                - 개인정보 보호책임자
                    - 성명 : 강태영
                    - 소속 : 개인정보보호팀
                    - 이메일 : [taengdev@gmail.com](mailto:taengdev@gmail.com)

                **제 5조 (개인정보보호책임자 및 담당자)**

                1. 운영팀은 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.
                    1. 개인정보 보호책임자
                        - 성명 : 강태영
                        - 소속 : 개인정보보호팀
                        - 이메일 : [taengdev@gmail.com](mailto:taengdev@gmail.com)
                2. 회원은 공부하개미 서비르를 이용하면서 발생한 모든 개인정보보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의할 수 있습니다. 운영팀은 회원의 문의에 대해 지체없이 답변 및 처리해드릴 것입니다.

                **제 6조(개인정보 처리방법 변경)**

                운영팀은 관련 법령이나 내부 정책 대응을 위하여 개인정보처리방침을 수정할 수 있습니다. 개인정보러처리방침이 변경되는 경우 회사는 변경 사항을 공지사항 등을 통해 게시하며, 변겨오딘 개인정보처리방침은 게시한 날로부터 7일후부터 효력이 발생합니다.

                공고일자 : 2024년 6월 일

                시행일자 : 2024년 6월 +7일
                """
            $0.numberOfLines = 0
            $0.font = UIFont(name: "Pretendard-Regular", size: 16)
            $0.textColor = UIColor(named: "fontBlack")
            $0.backgroundColor = UIColor(named: "viewBackgroundColor")
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(textView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(29)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        textView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
    }
}
