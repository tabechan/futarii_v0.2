import Foundation

struct MockData {
  static let userHusband = User(id: UUID(), name: "Taro", role: .husband)
  static let userWife = User(id: UUID(), name: "Hanako", role: .wife)

  static let lifeEvents: [LifeEvent] = LifeEventType.allCases.map { LifeEvent(type: $0) }

  static let items: [Item] = [
    // Fertility (妊活) focus
    Item(
      id: UUID(),
      lifeEventId: LifeEventType.fertility.id,
      type: .todo,
      title: "不妊検診の予約",
      description: "近所の評判の良いクリニックを予約する",
      owner: .wife,
      startAt: Date(),
      endAt: nil,
      isAllDay: true,
      status: .done,
      source: .manual,
      createdAt: Date(),
      updatedAt: Date()
    ),
    Item(
      id: UUID(),
      lifeEventId: LifeEventType.fertility.id,
      type: .todo,
      title: "基礎体温の記録開始",
      description: "毎朝決まった時間に計測する",
      owner: .wife,
      startAt: Date(),
      endAt: nil,
      isAllDay: true,
      status: .open,
      source: .manual,
      createdAt: Date(),
      updatedAt: Date()
    ),
    Item(
      id: UUID(),
      lifeEventId: LifeEventType.fertility.id,
      type: .todo,
      title: "精液検査の相談",
      description: "夫とクリニックへの同行について話し合う",
      owner: .both,
      startAt: Date().addingTimeInterval(86400),
      endAt: nil,
      isAllDay: true,
      status: .open,
      source: .manual,
      createdAt: Date(),
      updatedAt: Date()
    ),
    Item(
      id: UUID(),
      lifeEventId: LifeEventType.fertility.id,
      type: .event,
      title: "クリニック初診",
      description: "14:00〜。問診と超音波検査",
      owner: .both,
      startAt: Date().addingTimeInterval(86400 * 3 + 14 * 3600),
      endAt: Date().addingTimeInterval(86400 * 3 + 16 * 3600),
      isAllDay: false,
      status: .open,
      source: .manual,
      createdAt: Date(),
      updatedAt: Date()
    ),
  ]

  static let comparison: ComparisonMatrix = {
    let cid1 = UUID()
    let cid2 = UUID()
    let crid1 = UUID()
    let crid2 = UUID()
    let crid3 = UUID()

    return ComparisonMatrix(
      id: UUID(),
      lifeEventId: LifeEventType.preWedding.id,
      title: "式場比較",
      createdAt: Date(),
      candidates: [
        ComparisonCandidate(id: cid1, name: "ホテルA", memo: "伝統的"),
        ComparisonCandidate(id: cid2, name: "ゲストハウスB", memo: "おしゃれ"),
      ],
      criteria: [
        ComparisonCriteria(id: crid1, label: "料理", orderIndex: 0),
        ComparisonCriteria(id: crid2, label: "予算", orderIndex: 1),
        ComparisonCriteria(id: crid3, label: "雰囲気", orderIndex: 2),
      ],
      cellValues: [
        ComparisonCell(candidateId: cid1, criteriaId: crid1, score: 5, memo: "最高"),
        ComparisonCell(candidateId: cid1, criteriaId: crid2, score: 2, memo: "高い"),
        ComparisonCell(candidateId: cid1, criteriaId: crid3, score: 4, memo: "重厚"),
        ComparisonCell(candidateId: cid2, criteriaId: crid1, score: 3, memo: "普通"),
        ComparisonCell(candidateId: cid2, criteriaId: crid2, score: 4, memo: "手頃"),
        ComparisonCell(candidateId: cid2, criteriaId: crid3, score: 5, memo: "理想的"),
      ]
    )
  }()

  static let learningContents: [LearningContent] = [
    LearningContent(
      id: UUID(),
      title: "1. はじめる前のマインドセット",
      description: "不妊治療の全体像を捉える。不妊がもたらす「全人的苦痛」と「8つの喪失」について理解し、夫婦で向き合うための心構えを学びます。",
      body: """
        妊活と不妊治療は地続きであり、連続したものです。妊娠成立には男女両方の要素が関わります。

        特に初期段階で避けたい「女性が頑張るもの」「男性はサポート役」という思い込みを捨て、両者が当事者として取り組むことが重要です。男性も、自分の体の問題として精液検査や生活習慣の見直しを行う必要があります。

        カップルとしての課題として、検査開始のタイミングのズレや、片方だけが情報を集めていること、費用感の認識のズレなどがよく起きます。時間軸を意識しながら、女性・男性・カップルの3つの視点で現在地を把握し、一緒の地図を持つようにしましょう。
        """,
      quizzes: [
        QuizQuestion(
          id: UUID(),
          question: "妊活における適切なカップルの役割は次のうちどれですか？",
          options: ["女性が主役で男性は補助", "両者が当事者として取り組む", "男性が主役で女性は補助", "医師任せにする"],
          answerIndex: 1,
          explanation: "「女性が頑張るもの」「男性はサポート役」という思い込みを避け、両者が当事者であることが重要です。"
        ),
        QuizQuestion(
          id: UUID(),
          question: "不妊治療と妊活の捉え方として適切なのはどれですか？",
          options: [
            "妊活と不妊治療は地続きで連続したものである", "妊活は自然で、治療は不自然である", "まずは1年自己流で妊活すべきである", "女性だけの問題である",
          ],
          answerIndex: 0,
          explanation: "妊活と不妊治療は別のものではなく、連続した（地続きの）ものであると考えます。"
        ),
        QuizQuestion(
          id: UUID(),
          question: "カップル間で避けたい課題はどれですか？",
          options: ["一緒にクリニックを受診する", "片方だけが情報を集めている", "お互いの気持ちを共有する", "時間軸と生活設計を共有する"],
          answerIndex: 1,
          explanation: "片方だけが情報を集めていると認識のズレが生じやすく、避けるべき課題として挙げられています。"
        ),
      ],
      recommendedToDos: [
        ActionableToDo(id: UUID(), title: "2人で妊活方針を話す", description: "いつまで自然妊娠を目指すか、いつ検査を受けるか話し合う"),
        ActionableToDo(id: UUID(), title: "サポート方法の共有", description: "お互いにどんなサポートが助かるか話し合う"),
      ],
      lifeEventId: LifeEventType.fertility.id,
      completedBy: [],
      updatedAt: Date()
    ),
    LearningContent(
      id: UUID(),
      title: "2. 男女の課題と現在地の把握",
      description: "男女双方の視点から妊娠しやすさに影響する因子を理解し、お互いの状態を把握します。",
      body: """
        妊娠は女性だけのイベントではありません。

        【女性側の課題】
        排卵や卵管、子宮の課題、子宮内膜症などが影響します。加齢の影響は大きく、特に30代後半以降は妊孕性低下や流産率上昇が目立ちます。AMHは卵巣予備能の目安であり、妊娠可能性そのものを断定する値ではありません。

        【男性側の課題】
        造精機能障害（精子濃度が低い、運動率が低いなど）、精路通過障害、性機能障害、加齢や生活習慣が大きく影響します。男性因子はかなり高い割合で関与するため、男性側の評価が遅れると妊活全体の時間ロスになりやすいです。精子形成にはおよそ3か月かかるため、今からの生活習慣改善がとても重要です。
        """,
      quizzes: [
        QuizQuestion(
          id: UUID(),
          question: "妊娠のしやすさに影響する女性側の因子として間違っているものはどれですか？",
          options: ["年齢", "月経不順", "性機能障害", "子宮内膜症"],
          answerIndex: 2,
          explanation: "性機能障害（勃起障害など）は主に男性側の課題として挙げられています。"
        ),
        QuizQuestion(
          id: UUID(),
          question: "男性の精子形成におよそどれくらいの時間がかかるとされていますか？",
          options: ["1週間", "1か月", "3か月", "半年"],
          answerIndex: 2,
          explanation: "精子形成にはおよそ3か月かかるため、生活習慣の改善は3か月後に反映されます。"
        ),
        QuizQuestion(
          id: UUID(),
          question: "AMH検査の正しい解釈はどれですか？",
          options: ["妊娠可能性を断定する値である", "卵巣予備能の目安である", "今すぐ自然妊娠できるか分かる値", "高ければ必ず妊娠できる"],
          answerIndex: 1,
          explanation: "AMHはあくまで卵巣予備能の目安であり、妊娠可能性そのものを直接断定する値ではありません。"
        ),
      ],
      recommendedToDos: [
        ActionableToDo(id: UUID(), title: "既往歴と基礎体温の整理", description: "女性は基礎疾患や既往歴を整理し、月経周期を把握する"),
        ActionableToDo(
          id: UUID(), title: "生活習慣の改善", description: "男性は禁煙・節酒や睡眠改善、サウナなど高温曝露の見直しに取り組む"),
      ],
      lifeEventId: LifeEventType.fertility.id,
      completedBy: [],
      updatedAt: Date()
    ),
    LearningContent(
      id: UUID(),
      title: "3. 診断と検査の進め方",
      description: "現状を正しく把握するためのステップ。必要な検査の優先順位と考え方を学びます。",
      body: """
        検査は「全部やれば安心」ではなく、優先順位が大切です。

        女性側は、問診、ホルモン評価、超音波検査、卵管評価、子宮内の評価などを進めます。
        男性側は、精液検査や必要に応じた泌尿器科評価を行います。

        最も重要なのは、最初に「全体の見取り図」を作ることです。何が未評価で、どこがボトルネックかを明確にしないまま漫然と時間が過ぎることが、一番避けたい状態です。自己流で長く妊活しているが検査をしていない場合は、早めの受診が重要です。
        """,
      quizzes: [
        QuizQuestion(
          id: UUID(),
          question: "検査を進める上で最も重要な考え方はどれですか？",
          options: [
            "全部やれば安心なので全て受ける", "全体の見取り図を作り優先順位をつける", "女性の検査が全て終わるまで男性は待つ", "異常がなければ途中でやめてよい",
          ],
          answerIndex: 1,
          explanation: "検査は「全部やれば安心」ではなく、最初に全体の見取り図を作って優先順位をつけることが大切です。"
        ),
        QuizQuestion(
          id: UUID(),
          question: "最も避けたい状態はどれですか？",
          options: ["必要な検査を早く終わらせること", "ボトルネックを明確にすること", "未評価なまま漫然と時間が過ぎること", "夫婦で一緒に検査を受けること"],
          answerIndex: 2,
          explanation: "どこがボトルネックかを明確にしないまま漫然と時間が過ぎることが、最も避けたい状態です。"
        ),
        QuizQuestion(
          id: UUID(),
          question: "男性側が早めに受けるべき主要な初期検査は何ですか？",
          options: ["超音波検査", "月経歴の確認", "ホルモン評価のみ", "精液検査"],
          answerIndex: 3,
          explanation: "男性側は精液検査を早めに受けることが推奨されています。"
        ),
      ],
      recommendedToDos: [
        ActionableToDo(id: UUID(), title: "精液検査の予約", description: "泌尿器科や男性不妊に対応したクリニックで精液検査を受ける"),
        ActionableToDo(
          id: UUID(), title: "婦人科での検査相談", description: "基礎体温等の情報を持参し、必要な検査について医師と相談する"),
      ],
      lifeEventId: LifeEventType.fertility.id,
      completedBy: [],
      updatedAt: Date()
    ),
    LearningContent(
      id: UUID(),
      title: "4. 治療のロードマップとクリニック選び",
      description: "タイミング法から高度生殖医療までの治療の流れと、後悔しないクリニックの選び方を学びます。",
      body: """
        不妊治療には一般に、タイミング法、人工授精、体外受精、顕微授精などの段階があります。

        ただし、全員が必ず順番に進むものではありません。年齢、AMH、卵管因子、男性因子の強さによっては、早い段階で高度治療を検討した方が合理的な場合があります。ステップアップは「気持ちの問題」だけでなく、「時間の問題」でもあります。

        クリニックを選ぶ際は「有名だから」というだけでなく、「男性不妊の導線があるか」「費用表や保険の説明が明確か」「通院しやすいか」「初診で検査計画を言語化してくれるか」など、自分たちの課題や生活に合うかで選ぶことが大切です。
        """,
      quizzes: [
        QuizQuestion(
          id: UUID(),
          question: "治療のステップアップを進める上で重要な考え方はどれですか？",
          options: [
            "全員がタイミング法から順番に進むべき", "単なる気持ちの問題である", "気持ちの問題ではなく時間の問題でもある", "なるべくステップアップは避けるべき",
          ],
          answerIndex: 2,
          explanation: "ステップアップは気持ちの問題ではなく、時間の問題でもあるという視点が重要です。"
        ),
        QuizQuestion(
          id: UUID(),
          question: "クリニック選びで考慮すべきポイントとして不適切なものはどれですか？",
          options: ["「有名だから」という理由だけで選ぶ", "男性不妊の導線があるか確認する", "初診で検査計画を言語化してくれるか", "通院しやすいか"],
          answerIndex: 0,
          explanation: "「有名だから」だけでなく、自分たちの課題と生活に合うかで選ぶことが大切とされています。"
        ),
        QuizQuestion(
          id: UUID(),
          question: "年齢や検査結果によってはどうすることが合理的とされていますか？",
          options: ["必ず自己流で半年は頑張る", "早い段階で高度治療を検討する", "漢方など自然な方法のみに頼る", "もう少し待ってから治療を始める"],
          answerIndex: 1,
          explanation: "年齢や因子の強さによっては、早い段階で高度治療を検討した方が合理的な場合があります。"
        ),
      ],
      recommendedToDos: [
        ActionableToDo(
          id: UUID(), title: "クリニック候補のリストアップ", description: "通いやすさや男性不妊対応の有無などを基準にクリニックを探す"),
        ActionableToDo(
          id: UUID(), title: "ステップアップの期限の相談", description: "いつまで今の段階を続けるか、次のステップへ進む時期を話し合う"),
      ],
      lifeEventId: LifeEventType.fertility.id,
      completedBy: [],
      updatedAt: Date()
    ),
    LearningContent(
      id: UUID(),
      title: "5. 保険・費用と仕事との両立",
      description: "想定外の負担を防ぐための費用・制度の確認と、通院と仕事を両立するための実践的アプローチ。",
      body: """
        不妊治療には保険適用と先進医療・自費になるものがあります。年齢や回数の条件、クリニックごとの費用表やスケジュールの違いを最初に確認することが大切です。

        高い治療が常に最適とは限りません。自分たちの課題に対して「何を改善したいのか」を明確にしましょう。

        通院回数や急な受診、待ち時間は仕事との両立の大きな障壁になります。半休や時間休の使い方、テレワークの可否、必要最小限の職場への共有、パートナー間での送迎や家事分担の見直しなど、現実的な対策を講じることが重要です。最初の90日間で情報を整理し、方針を固めることが鍵になります。
        """,
      quizzes: [
        QuizQuestion(
          id: UUID(),
          question: "治療費用について最初に確認すべきこととして当てはまらないものはどれですか？",
          options: ["保険適用の対象範囲", "クレジットカードのポイント還元率", "年齢や回数の条件", "助成や会社制度の有無"],
          answerIndex: 1,
          explanation: "保険適用の範囲や条件、助成制度の有無を最初に確認することが推奨されています。"
        ),
        QuizQuestion(
          id: UUID(),
          question: "仕事との両立の対策として推奨されているものはどれですか？",
          options: ["会社をすぐに辞める", "職場の全員に詳細を報告する", "パートナー間で送迎や家事分担を見直す", "通院を諦める"],
          answerIndex: 2,
          explanation: "パートナー間で送迎や家事分担を見直すなど、現実的な対策を講じることが挙げられています。"
        ),
        QuizQuestion(
          id: UUID(),
          question: "妊活開始から最初の90日で目指すべきことは何ですか？",
          options: ["何もせずに自然に任せる", "情報を整理し、方針を共有して受診を進める", "最も高額な治療をすぐに始める", "一人で全て決断する"],
          answerIndex: 1,
          explanation: "最初の90日で2人で方針を話し、検査を進めて治療方針を決定・共有することが推奨されています。"
        ),
      ],
      recommendedToDos: [
        ActionableToDo(id: UUID(), title: "会社の休暇・助成制度の確認", description: "お互いの職場で利用できる制度がないかを調べる"),
        ActionableToDo(
          id: UUID(), title: "通院時の家事分担ルールの決定", description: "急な受診や休みに備えて、家事等の分担を具体的に決める"),
      ],
      lifeEventId: LifeEventType.fertility.id,
      completedBy: [],
      updatedAt: Date()
    ),
  ]
}
